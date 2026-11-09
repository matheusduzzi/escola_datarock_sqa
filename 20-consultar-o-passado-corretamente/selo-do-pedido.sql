-- Cada pedido da base acha o selo do dia em que foi feito. Antes de usar o resultado,
-- a conta: quantos pedidos entraram, quantos saíram, quantos acharam mais de um selo e quantos nenhum.
CREATE VIEW selo_cliente AS SELECT * FROM read_csv('dados/selo_cliente.csv', header = true);

WITH com_selo AS (
    SELECT p.id_pedido, CAST(p.data_hora_pedido AS DATE) AS dia, s.selo
    FROM pedidos p
    LEFT JOIN selo_cliente s
      ON s.id_cliente = p.id_cliente
     AND s.valido_de <= CAST(p.data_hora_pedido AS DATE)
     AND CAST(p.data_hora_pedido AS DATE) < s.valido_ate
),
por_pedido AS (
    SELECT id_pedido, MIN(dia) AS dia, COUNT(selo) AS selos
    FROM com_selo
    GROUP BY id_pedido
),
com_join_comum AS (
    SELECT COUNT(*) AS linhas
    FROM pedidos p
    JOIN selo_cliente s
      ON s.id_cliente = p.id_cliente
     AND s.valido_de <= CAST(p.data_hora_pedido AS DATE)
     AND CAST(p.data_hora_pedido AS DATE) < s.valido_ate
)
SELECT conta, n FROM (
SELECT 1 AS ordem, 'pedidos na base' AS conta, (SELECT COUNT(*) FROM pedidos) AS n
UNION ALL SELECT 2, 'linhas depois do LEFT JOIN', (SELECT COUNT(*) FROM com_selo)
UNION ALL SELECT 3, 'pedidos com mais de um selo', (SELECT COUNT(*) FROM por_pedido WHERE selos > 1)
UNION ALL SELECT 4, 'pedidos sem selo', (SELECT COUNT(*) FROM por_pedido WHERE selos = 0)
UNION ALL SELECT 5, 'pedidos sem selo antes de fevereiro', (SELECT COUNT(*) FROM por_pedido WHERE selos = 0 AND dia < DATE '2026-02-01')
UNION ALL SELECT 6, 'linhas com JOIN comum', (SELECT linhas FROM com_join_comum)
) t
ORDER BY ordem;
