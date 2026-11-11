-- Controle de frete: as seis etapas do modelo da aula 36, uma view por etapa.
-- Cada etapa diz no comentário o que é uma linha dela.
-- Rodar: python3 projeto.py etapas.sql
-- O SELECT do fim mostra quantas linhas cada etapa tem.

-- 1. cobrancas: uma linha por linha da tabela entregas, de pedido não cancelado.
CREATE OR REPLACE VIEW cobrancas AS
SELECT e.id_entrega,
       e.id_pedido,
       e.volume,
       e.tentativa,
       e.tipo,
       e.transportadora,
       e.data_tentativa,
       e.resultado,
       e.custo_frete,
       CASE WHEN e.tipo = 'devolucao'           THEN 'devolucao'
            WHEN e.resultado = 'nao_encontrado' THEN 'falhou'
            WHEN e.resultado = 'entregue'       THEN 'entrega'
            WHEN e.resultado IS NULL            THEN 'na_rua'
       END                                          AS parte,  -- sem ELSE: valor novo fica vazio e o teste acusa
       CAST(date_trunc('month', p.data_hora_pedido) AS DATE) AS mes_pedido,
       CAST(date_trunc('month', e.data_tentativa) AS DATE)   AS mes_tentativa
FROM entregas e
JOIN pedidos p USING (id_pedido)
WHERE p.status <> 'cancelado';

-- 2. frete_por_pedido: uma linha por pedido não cancelado.
CREATE OR REPLACE VIEW frete_por_pedido AS
SELECT id_pedido,
       MIN(mes_pedido)      AS mes_pedido,      -- é o mesmo em todas as linhas do pedido
       MIN(transportadora)  AS transportadora,  -- premissa 1: uma só por pedido
       SUM(custo_frete)     AS frete,
       COALESCE(SUM(custo_frete) FILTER (WHERE parte = 'entrega'), 0)   AS entrega,
       COALESCE(SUM(custo_frete) FILTER (WHERE parte = 'falhou'), 0)    AS falhou,
       COALESCE(SUM(custo_frete) FILTER (WHERE parte = 'devolucao'), 0) AS devolucao,
       COUNT(*) FILTER (WHERE parte = 'entrega')      AS volumes_entregues,
       COUNT(*) FILTER (WHERE custo_frete IS NULL)    AS linhas_sem_fatura,
       COUNT(*) FILTER (WHERE parte = 'na_rua')       AS volumes_na_rua
FROM cobrancas
GROUP BY id_pedido;

-- 3. rateio_por_item: uma linha por item de pedido não cancelado.
-- O frete chega aqui já somado por pedido. A janela calcula o valor do pedido em cada linha.
CREATE OR REPLACE VIEW rateio_por_item AS
WITH itens AS (
    SELECT i.id_pedido,
           i.n_item,
           d.categoria,
           i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0) AS valor_item  -- desconto vazio: sem cupom
    FROM itens_pedido i
    JOIN produtos d USING (id_produto)
)
SELECT it.id_pedido,
       it.n_item,
       it.categoria,
       f.mes_pedido,
       f.transportadora,
       it.valor_item,
       it.valor_item / SUM(it.valor_item) OVER (PARTITION BY it.id_pedido)           AS participacao,
       f.frete * it.valor_item / SUM(it.valor_item) OVER (PARTITION BY it.id_pedido) AS parte_do_frete
FROM itens it
JOIN frete_por_pedido f USING (id_pedido);

-- 4. controle_mensal: uma linha por mês do pedido e transportadora. Métricas 1 a 4 do contrato.
CREATE OR REPLACE VIEW controle_mensal AS
WITH somas AS (
    SELECT mes_pedido               AS mes,
           transportadora,
           COUNT(*)                 AS pedidos,
           SUM(volumes_entregues)   AS volumes_entregues,
           SUM(frete)               AS frete,
           SUM(falhou)              AS falhou,
           SUM(devolucao)           AS devolucao,
           SUM(linhas_sem_fatura)   AS linhas_sem_fatura,
           SUM(volumes_na_rua)      AS volumes_na_rua
    FROM frete_por_pedido
    GROUP BY mes_pedido, transportadora
),
metricas AS (
    SELECT *,
           frete / pedidos                                  AS por_pedido,
           frete / volumes_entregues                        AS por_volume,
           100 * falhou / frete                             AS pct_falhou,
           100 * devolucao / frete                          AS pct_devolucao,
           linhas_sem_fatura = 0 AND volumes_na_rua = 0     AS fechado
    FROM somas
)
SELECT *,
       100 * frete / SUM(frete) OVER (PARTITION BY mes)     AS pct_do_frete_do_mes,
       -- Variação contra o mês anterior da mesma transportadora, só entre dois meses fechados e vizinhos.
       CASE WHEN fechado
             AND LAG(fechado) OVER por_transportadora
             AND LAG(mes) OVER por_transportadora = mes - INTERVAL 1 MONTH
            THEN por_pedido - LAG(por_pedido) OVER por_transportadora
       END                                                   AS variacao_por_pedido
FROM metricas
WINDOW por_transportadora AS (PARTITION BY transportadora ORDER BY mes);

-- 5. frete_por_categoria: uma linha por mês do pedido e categoria. Métrica 6.
CREATE OR REPLACE VIEW frete_por_categoria AS
SELECT mes_pedido                                    AS mes,
       categoria,
       SUM(valor_item)                               AS venda,
       SUM(parte_do_frete)                           AS frete,
       100 * SUM(parte_do_frete) / SUM(valor_item)   AS pct_da_venda
FROM rateio_por_item
GROUP BY mes_pedido, categoria;

-- 6. tentativas_do_mes: uma linha por mês da tentativa e transportadora. Métrica 5.
-- Volume na rua ainda não tem tentativa e fica fora até ter.
CREATE OR REPLACE VIEW tentativas_do_mes AS
SELECT mes_tentativa                                 AS mes,
       transportadora,
       COUNT(*)                                      AS linhas,
       SUM(custo_frete)                              AS frete,
       COUNT(*) FILTER (WHERE custo_frete IS NULL)   AS linhas_sem_fatura
FROM cobrancas
WHERE data_tentativa IS NOT NULL
GROUP BY mes_tentativa, transportadora;

-- Quantas linhas cada etapa tem.
SELECT 1 AS n, 'cobrancas' AS etapa, 'linha de entregas' AS uma_linha_por, COUNT(*) AS linhas FROM cobrancas
UNION ALL SELECT 2, 'frete_por_pedido', 'pedido não cancelado', COUNT(*) FROM frete_por_pedido
UNION ALL SELECT 3, 'rateio_por_item', 'item de pedido', COUNT(*) FROM rateio_por_item
UNION ALL SELECT 4, 'controle_mensal', 'mês do pedido e transportadora', COUNT(*) FROM controle_mensal
UNION ALL SELECT 5, 'frete_por_categoria', 'mês do pedido e categoria', COUNT(*) FROM frete_por_categoria
UNION ALL SELECT 6, 'tentativas_do_mes', 'mês da tentativa e transportadora', COUNT(*) FROM tentativas_do_mes
ORDER BY n;
