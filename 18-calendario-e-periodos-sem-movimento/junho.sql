-- Pedidos por mês, com quantos dias do mês a base cobre.
-- O corte é o dia do último pedido da base.
WITH corte AS (
  SELECT CAST(MAX(data_hora_pedido) AS DATE) AS dia FROM pedidos
),
meses AS (
  SELECT CAST(inicio AS DATE) AS inicio,
         CAST(inicio + INTERVAL 1 MONTH AS DATE) AS fim
  FROM range(TIMESTAMP '2026-01-01', TIMESTAMP '2026-07-01', INTERVAL 1 MONTH) AS t(inicio)
)
SELECT strftime(m.inicio, '%Y-%m') AS mes,
       m.fim - m.inicio AS dias_no_mes,
       LEAST(m.fim, c.dia + 1) - m.inicio AS dias_com_dados,
       COUNT(p.id_pedido) AS pedidos,
       COUNT(p.id_pedido) FILTER (WHERE day(p.data_hora_pedido) <= 20) AS pedidos_dia_1_a_20,
       ROUND(COUNT(p.id_pedido) / (LEAST(m.fim, c.dia + 1) - m.inicio), 2) AS pedidos_por_dia
FROM meses m
CROSS JOIN corte c
LEFT JOIN pedidos p
  ON p.data_hora_pedido >= m.inicio
 AND p.data_hora_pedido <  m.fim
GROUP BY m.inicio, m.fim, c.dia
ORDER BY m.inicio;
