-- Um pedido no fato com o frete copiado: o pedido 33. Troque o número para ver outro.
-- A parte 1 monta o modelo estrela das vendas. Ela é igual em estrela.sql, prova.sql,
-- vendas-categoria-mes.sql, frete-no-item.sql e um-pedido.sql.
-- A parte 2 é a pergunta. Só o resultado do último SELECT aparece na tela.

-- 1. Montar o modelo
CREATE TABLE dim_data AS
SELECT CAST(range AS DATE)         AS data,
       year(range)                 AS ano,
       month(range)                AS mes,
       strftime(range, '%Y-%m')    AS ano_mes,
       isodow(range)               AS dia_semana   -- 1 é segunda, 7 é domingo
FROM range(TIMESTAMP '2026-01-01', TIMESTAMP '2026-07-01', INTERVAL 1 DAY);

CREATE TABLE dim_produto AS
SELECT id_produto, nome AS produto, categoria
FROM produtos;

CREATE TABLE dim_cliente AS
SELECT id_cliente, cidade, uf
FROM clientes;

CREATE TABLE fato_vendas AS
SELECT i.id_pedido,
       i.n_item,
       CAST(p.data_hora_pedido AS DATE)                           AS data,
       p.id_cliente,
       i.id_produto,
       p.canal,
       p.status,
       i.quantidade,
       i.quantidade * i.preco_unitario                            AS valor_bruto,
       COALESCE(i.desconto, 0)                                    AS desconto,
       i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)  AS valor_liquido
FROM itens_pedido i
JOIN pedidos p ON p.id_pedido = i.id_pedido;

-- 2. O frete do pedido copiado em cada item, num pedido só
CREATE TABLE fato_com_frete AS
SELECT f.*, e.frete_do_pedido
FROM fato_vendas f
LEFT JOIN (SELECT id_pedido, SUM(custo_frete) AS frete_do_pedido
           FROM entregas GROUP BY id_pedido) e ON e.id_pedido = f.id_pedido;

SELECT f.n_item, p.produto, p.categoria, f.valor_liquido, f.frete_do_pedido
FROM fato_com_frete f
JOIN dim_produto p ON p.id_produto = f.id_produto
WHERE f.id_pedido = 33
ORDER BY f.n_item;
