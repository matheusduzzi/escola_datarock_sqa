-- Três jeitos de escrever "de 1º a 20 de junho" e quantos pedidos não cancelados cada um pega.
SELECT 'BETWEEN com texto' AS filtro,
       COUNT(*) FILTER (WHERE data_hora_pedido BETWEEN '2026-06-01' AND '2026-06-20') AS pedidos
FROM pedidos WHERE status <> 'cancelado'
UNION ALL
SELECT 'BETWEEN com CAST para data',
       COUNT(*) FILTER (WHERE CAST(data_hora_pedido AS DATE) BETWEEN DATE '2026-06-01' AND DATE '2026-06-20')
FROM pedidos WHERE status <> 'cancelado'
UNION ALL
SELECT 'maior ou igual e menor que',
       COUNT(*) FILTER (WHERE data_hora_pedido >= TIMESTAMP '2026-06-01 00:00:00'
                          AND data_hora_pedido <  TIMESTAMP '2026-06-21 00:00:00')
FROM pedidos WHERE status <> 'cancelado'
