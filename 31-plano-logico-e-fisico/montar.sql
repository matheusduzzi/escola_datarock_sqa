-- Monta as camadas do painel no arquivo loja.duckdb, nesta pasta.
-- Cada view tem o contrato de saída escrito em cima dela.
-- Rodar de novo recria as views do mesmo jeito.
ATTACH 'loja.duckdb' AS loja;

-- ============================================================
-- CAMADA 1. PREPARAÇÃO
-- Lê os CSVs, dá nome e tipo a cada coluna e trata o vazio que
-- o dicionário da base explica. Não filtra e não junta tabelas.
-- ============================================================

-- prep_pedidos
--   Lê: ../dados/pedidos.csv
--   Uma linha por: pedido, as mesmas 900 linhas do CSV.
--   Chave: id_pedido.
--   Colunas:
--     id_pedido, id_cliente  INTEGER
--     data_hora_pedido       TIMESTAMP
--     mes                    DATE     primeiro dia do mês do pedido
--     canal                  VARCHAR  site, app, loja
--     status                 VARCHAR  entregue, cancelado, devolvido, em_andamento
--   Quem lê: regra_pedido.
CREATE OR REPLACE VIEW loja.prep_pedidos AS
SELECT id_pedido,
       id_cliente,
       data_hora_pedido,
       CAST(date_trunc('month', data_hora_pedido) AS DATE) AS mes,
       canal,
       status
FROM read_csv('../dados/pedidos.csv', header = true, columns = {
    'id_pedido': 'INTEGER', 'id_cliente': 'INTEGER', 'data_hora_pedido': 'TIMESTAMP',
    'canal': 'VARCHAR', 'status': 'VARCHAR'});

-- prep_itens
--   Lê: ../dados/itens_pedido.csv
--   Uma linha por: item de pedido, as mesmas 1570 linhas do CSV.
--   Chave: id_pedido + n_item.
--   Colunas:
--     id_pedido, n_item, id_produto, quantidade  INTEGER
--     preco_unitario  DECIMAL(10,2)
--     desconto        DECIMAL(10,2)  0 quando o CSV vem vazio (vazio = item sem cupom)
--     valor_item      DECIMAL        quantidade * preco_unitario - desconto; nunca vazio
--   Quem lê: regra_pedido.
CREATE OR REPLACE VIEW loja.prep_itens AS
SELECT id_pedido,
       n_item,
       id_produto,
       quantidade,
       preco_unitario,
       COALESCE(desconto, 0) AS desconto,
       quantidade * preco_unitario - COALESCE(desconto, 0) AS valor_item
FROM read_csv('../dados/itens_pedido.csv', header = true, columns = {
    'id_pedido': 'INTEGER', 'n_item': 'INTEGER', 'id_produto': 'INTEGER',
    'quantidade': 'INTEGER', 'preco_unitario': 'DECIMAL(10,2)', 'desconto': 'DECIMAL(10,2)'});

-- prep_pagamentos
--   Lê: ../dados/pagamentos.csv
--   Uma linha por: transação de pagamento, as mesmas 1040 linhas do CSV.
--   Chave: id_pagamento.
--   Colunas:
--     id_pagamento, id_pedido  INTEGER
--     data_hora_pagamento      TIMESTAMP
--     forma                    VARCHAR  cartao, pix, boleto
--     valor                    DECIMAL(10,2)
--     status                   VARCHAR  aprovado, recusado, estornado, pendente
--   Quem lê: regra_pedido.
CREATE OR REPLACE VIEW loja.prep_pagamentos AS
SELECT id_pagamento, id_pedido, data_hora_pagamento, forma, valor, status
FROM read_csv('../dados/pagamentos.csv', header = true, columns = {
    'id_pagamento': 'INTEGER', 'id_pedido': 'INTEGER', 'data_hora_pagamento': 'TIMESTAMP',
    'forma': 'VARCHAR', 'valor': 'DECIMAL(10,2)', 'status': 'VARCHAR'});

-- ============================================================
-- CAMADA 2. REGRA
-- As definições do negócio, num lugar só: o valor do pedido,
-- o que foi recebido, o que conta como venda e o que falta
-- receber. Lê só a preparação.
-- ============================================================

-- regra_pedido
--   Lê: prep_pedidos, prep_itens, prep_pagamentos
--   Uma linha por: pedido, de qualquer status (900 linhas).
--   Chave: id_pedido, sem repetir.
--   Colunas:
--     id_pedido         INTEGER
--     mes               DATE     mês do pedido
--     canal, status     VARCHAR
--     itens             INTEGER  quantos itens o pedido tem
--     valor             DECIMAL  soma de valor_item do pedido; nunca vazio
--     recebido          DECIMAL  pagamentos aprovados menos estornados; 0 sem pagamento
--     conta_como_venda  BOOLEAN  verdadeiro só para status entregue
--     falta_receber     DECIMAL  valor - recebido nos pedidos entregues ou em andamento; 0 nos outros
--   Regra de junção: itens e pagamentos são somados por pedido ANTES de juntar.
--   Quem lê: consumo_painel_mes, consumo_cobranca e qualquer relatório novo.
CREATE OR REPLACE VIEW loja.regra_pedido AS
WITH itens AS (
    SELECT id_pedido, COUNT(*) AS itens, SUM(valor_item) AS valor
    FROM loja.prep_itens
    GROUP BY id_pedido
),
pagos AS (
    SELECT id_pedido,
           SUM(CASE WHEN status = 'aprovado'  THEN valor ELSE 0 END)
         - SUM(CASE WHEN status = 'estornado' THEN valor ELSE 0 END) AS recebido
    FROM loja.prep_pagamentos
    GROUP BY id_pedido
)
SELECT p.id_pedido,
       p.mes,
       p.canal,
       p.status,
       i.itens,
       i.valor,
       COALESCE(g.recebido, 0) AS recebido,
       p.status = 'entregue' AS conta_como_venda,
       CASE WHEN p.status IN ('entregue', 'em_andamento')
            THEN i.valor - COALESCE(g.recebido, 0) ELSE 0 END AS falta_receber
FROM loja.prep_pedidos p
LEFT JOIN itens i ON i.id_pedido = p.id_pedido
LEFT JOIN pagos g ON g.id_pedido = p.id_pedido;

-- ============================================================
-- CAMADA 3. CONSUMO
-- Uma view por relatório, com o formato que quem lê precisa:
-- nomes, ordem, arredondamento. Lê só a regra.
-- ============================================================

-- consumo_painel_mes
--   Lê: regra_pedido
--   Para: painel da Lúcia, gerente comercial.
--   Uma linha por: mês do pedido (6 linhas, janeiro a junho de 2026).
--   Chave: mes.
--   Colunas:
--     mes               VARCHAR  'AAAA-MM'
--     pedidos_vendidos  BIGINT   pedidos que contam como venda
--     vendido           DECIMAL  soma do valor desses pedidos, 2 casas
--     recebido          DECIMAL  soma do recebido de todos os pedidos do mês, 2 casas
CREATE OR REPLACE VIEW loja.consumo_painel_mes AS
SELECT strftime(mes, '%Y-%m') AS mes,
       COUNT(*) FILTER (WHERE conta_como_venda) AS pedidos_vendidos,
       ROUND(SUM(valor) FILTER (WHERE conta_como_venda), 2) AS vendido,
       ROUND(SUM(recebido), 2) AS recebido
FROM loja.regra_pedido
GROUP BY mes
ORDER BY mes;

-- consumo_cobranca
--   Lê: regra_pedido
--   Para: financeiro, lista de cobrança.
--   Uma linha por: pedido com falta_receber maior que 0.
--   Chave: id_pedido.
--   Colunas: id_pedido, mes ('AAAA-MM'), canal, status, valor, recebido, falta_receber.
CREATE OR REPLACE VIEW loja.consumo_cobranca AS
SELECT id_pedido, strftime(mes, '%Y-%m') AS mes, canal, status, valor, recebido, falta_receber
FROM loja.regra_pedido
WHERE falta_receber > 0
ORDER BY id_pedido;

-- O que ficou no arquivo, camada por camada.
SELECT 'preparação' AS camada, 'prep_pedidos' AS view, COUNT(*) AS linhas FROM loja.prep_pedidos
UNION ALL SELECT 'preparação', 'prep_itens', COUNT(*) FROM loja.prep_itens
UNION ALL SELECT 'preparação', 'prep_pagamentos', COUNT(*) FROM loja.prep_pagamentos
UNION ALL SELECT 'regra', 'regra_pedido', COUNT(*) FROM loja.regra_pedido
UNION ALL SELECT 'consumo', 'consumo_painel_mes', COUNT(*) FROM loja.consumo_painel_mes
UNION ALL SELECT 'consumo', 'consumo_cobranca', COUNT(*) FROM loja.consumo_cobranca;
