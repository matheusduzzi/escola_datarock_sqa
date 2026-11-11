-- A consulta do Caio para o pedido do exercício: pedidos de Esporte por dia,
-- de 23/03 a 05/04/2026, com o dia anterior pelo LAG.
WITH por_dia AS (
  SELECT CAST(p.data_hora_pedido AS DATE) AS dia,
         COUNT(DISTINCT p.id_pedido) AS pedidos
  FROM pedidos p
  JOIN itens_pedido i USING (id_pedido)
  JOIN produtos d USING (id_produto)
  WHERE d.categoria = 'Esporte'
    AND p.data_hora_pedido >= TIMESTAMP '2026-03-23'
    AND p.data_hora_pedido < TIMESTAMP '2026-04-06'
  GROUP BY 1
)
SELECT dia,
       pedidos,
       LAG(pedidos) OVER (ORDER BY dia) AS dia_anterior,
       ROUND(100.0 * (pedidos - LAG(pedidos) OVER (ORDER BY dia)) / LAG(pedidos) OVER (ORDER BY dia), 1) AS variacao_pct
FROM por_dia
ORDER BY dia;
