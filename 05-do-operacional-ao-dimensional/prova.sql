-- O fato bate com a tabela de itens? Toda linha do fato acha a sua dimensão?
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

-- 2. O fato contra a origem, e as linhas do fato sem par nas dimensões
SELECT (SELECT COUNT(*) FROM fato_vendas)                                   AS linhas_fato,
       (SELECT COUNT(*) FROM itens_pedido)                                  AS linhas_itens,
       (SELECT ROUND(SUM(valor_liquido), 2) FROM fato_vendas)               AS valor_fato,
       (SELECT ROUND(SUM(quantidade * preco_unitario - COALESCE(desconto, 0)), 2)
          FROM itens_pedido)                                                AS valor_itens,
       (SELECT COUNT(*) FROM fato_vendas f
          WHERE NOT EXISTS (SELECT 1 FROM dim_data d WHERE d.data = f.data))           AS sem_data,
       (SELECT COUNT(*) FROM fato_vendas f
          WHERE NOT EXISTS (SELECT 1 FROM dim_produto d WHERE d.id_produto = f.id_produto)) AS sem_produto,
       (SELECT COUNT(*) FROM fato_vendas f
          WHERE NOT EXISTS (SELECT 1 FROM dim_cliente d WHERE d.id_cliente = f.id_cliente)) AS sem_cliente;
