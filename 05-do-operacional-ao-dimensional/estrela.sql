-- O modelo estrela das vendas e o teste da chave de cada tabela.
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

-- 2. A chave de cada tabela: linhas contra combinações diferentes
SELECT 'dim_data' AS tabela, COUNT(*) AS linhas,
       (SELECT COUNT(*) FROM (SELECT DISTINCT data FROM dim_data)) AS chaves_diferentes
FROM dim_data
UNION ALL
SELECT 'dim_produto', COUNT(*), (SELECT COUNT(*) FROM (SELECT DISTINCT id_produto FROM dim_produto))
FROM dim_produto
UNION ALL
SELECT 'dim_cliente', COUNT(*), (SELECT COUNT(*) FROM (SELECT DISTINCT id_cliente FROM dim_cliente))
FROM dim_cliente
UNION ALL
SELECT 'fato_vendas', COUNT(*), (SELECT COUNT(*) FROM (SELECT DISTINCT id_pedido, n_item FROM fato_vendas))
FROM fato_vendas;
