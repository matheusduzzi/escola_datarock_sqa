-- A consulta com a etapa por pedido e a consulta sem ela, em dois casos escritos à mão. É o pedido 3 da prática.
-- Caso 1: o pedido 3 tem um item sem valor. Caso 2: um item chegou sem id_pedido.
WITH itens AS (
    SELECT * FROM (VALUES
        ('1. pedido sem valor',    1,    'app', 100.00),
        ('1. pedido sem valor',    1,    'app',  50.00),
        ('1. pedido sem valor',    2,    'app', 300.00),
        ('1. pedido sem valor',    3,    'app', NULL),
        ('2. item sem id_pedido',  1,    'app', 100.00),
        ('2. item sem id_pedido',  1,    'app',  50.00),
        ('2. item sem id_pedido',  2,    'app', 300.00),
        ('2. item sem id_pedido',  NULL, 'app',  80.00)
    ) AS t(caso, id_pedido, canal, valor)
), com_cte AS (
    WITH por_pedido AS (
        SELECT caso, id_pedido, canal, SUM(valor) AS valor_pedido FROM itens GROUP BY caso, id_pedido, canal
    )
    SELECT caso, canal, COUNT(*) AS pedidos, SUM(valor_pedido) AS vendido, ROUND(AVG(valor_pedido), 2) AS ticket_medio
    FROM por_pedido GROUP BY caso, canal
), sem_cte AS (
    SELECT caso, canal, COUNT(DISTINCT id_pedido) AS pedidos, SUM(valor) AS vendido,
           ROUND(SUM(valor) / COUNT(DISTINCT id_pedido), 2) AS ticket_medio
    FROM itens GROUP BY caso, canal
)
SELECT caso, 'com a CTE' AS versao, pedidos, vendido, ticket_medio FROM com_cte
UNION ALL
SELECT caso, 'sem a CTE', pedidos, vendido, ticket_medio FROM sem_cte
ORDER BY caso, versao;
