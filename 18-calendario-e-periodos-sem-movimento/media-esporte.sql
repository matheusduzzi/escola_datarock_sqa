-- Três médias mensais de pedidos de Esporte, com três divisores diferentes.
WITH esporte AS (
  SELECT strftime(p.data_hora_pedido, '%Y-%m') AS mes,
         COUNT(DISTINCT p.id_pedido) AS pedidos
  FROM pedidos p
  JOIN itens_pedido i USING (id_pedido)
  JOIN produtos d USING (id_produto)
  WHERE d.categoria = 'Esporte'
  GROUP BY mes
)
SELECT conta, meses, pedidos, ROUND(pedidos / meses, 1) AS media
FROM (
  SELECT 1 AS ordem, 'AVG nas linhas do Caio' AS conta, COUNT(*) AS meses, SUM(pedidos) AS pedidos
  FROM esporte
  UNION ALL
  SELECT 2, 'seis meses, abril com zero', 6, SUM(pedidos)
  FROM esporte
  UNION ALL
  SELECT 3, 'janeiro a maio, abril com zero', 5, SUM(pedidos)
  FROM esporte WHERE mes <= '2026-05'
)
ORDER BY ordem;
