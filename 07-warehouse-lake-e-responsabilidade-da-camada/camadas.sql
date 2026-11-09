-- 1. Montar as camadas

-- Bruto: os três arquivos como chegaram, tudo texto, com o nome do arquivo.
CREATE VIEW bruto_pedidos AS
SELECT * FROM read_csv('../dados/pedidos.csv', all_varchar = true, filename = true);
CREATE VIEW bruto_itens AS
SELECT * FROM read_csv('../dados/itens_pedido.csv', all_varchar = true, filename = true);
CREATE VIEW bruto_produtos AS
SELECT * FROM read_csv('../dados/produtos.csv', all_varchar = true, filename = true);

-- Tratado: uma linha para cada linha da origem, com o tipo certo. Nenhuma regra de venda.
CREATE VIEW tratado_pedidos AS
SELECT
    CAST(id_pedido AS INTEGER)          AS id_pedido,
    CAST(id_cliente AS INTEGER)         AS id_cliente,
    CAST(data_hora_pedido AS TIMESTAMP) AS data_hora_pedido,
    canal,
    status
FROM bruto_pedidos;

CREATE VIEW tratado_itens AS
SELECT
    CAST(id_pedido AS INTEGER)               AS id_pedido,
    CAST(n_item AS INTEGER)                  AS n_item,
    CAST(id_produto AS INTEGER)              AS id_produto,
    CAST(quantidade AS INTEGER)              AS quantidade,
    CAST(preco_unitario AS DECIMAL(10, 2))   AS preco_unitario,
    CAST(desconto AS DECIMAL(10, 2))         AS desconto      -- vazio continua vazio
FROM bruto_itens;

CREATE VIEW tratado_produtos AS
SELECT
    CAST(id_produto AS INTEGER)              AS id_produto,
    nome,
    categoria,
    CAST(preco_lista AS DECIMAL(10, 2))      AS preco_lista
FROM bruto_produtos;

-- Consumo: a regra do valor da venda, escrita uma vez. Todo painel de vendas lê daqui.
-- Uma linha por item, com todos os status: o recorte fica na pergunta.
CREATE VIEW consumo_vendas AS
SELECT
    i.id_pedido,
    i.n_item,
    CAST(p.data_hora_pedido AS DATE)                           AS data,
    p.canal,
    p.status,
    d.categoria,
    i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)  AS valor_liquido
FROM tratado_itens i
JOIN tratado_pedidos  p ON p.id_pedido  = i.id_pedido
JOIN tratado_produtos d ON d.id_produto = i.id_produto;

-- 2. Quantas linhas de item em cada camada, e janeiro no consumo
SELECT
    (SELECT COUNT(*) FROM bruto_itens)    AS bruto,
    (SELECT COUNT(*) FROM tratado_itens)  AS tratado,
    (SELECT COUNT(*) FROM consumo_vendas) AS consumo,
    (SELECT SUM(valor_liquido) FROM consumo_vendas
      WHERE data >= DATE '2026-01-01' AND data < DATE '2026-02-01') AS janeiro_todos_status,
    (SELECT SUM(valor_liquido) FROM consumo_vendas
      WHERE data >= DATE '2026-01-01' AND data < DATE '2026-02-01'
        AND status IN ('entregue', 'em_andamento'))                  AS janeiro_vendido;
