-- A consulta do Caio: pedidos por mês e categoria com GROUP BY e, ao lado,
-- o mês anterior pelo LAG. Mostra só Esporte.
WITH por_mes AS (
  SELECT CAST(date_trunc('month', p.data_hora_pedido) AS DATE) AS mes,
         d.categoria,
         COUNT(DISTINCT p.id_pedido) AS pedidos
  FROM pedidos p
  JOIN itens_pedido i USING (id_pedido)
  JOIN produtos d USING (id_produto)
  GROUP BY 1, 2
),
com_anterior AS (
  SELECT mes, categoria, pedidos,
         LAG(pedidos) OVER (PARTITION BY categoria ORDER BY mes) AS mes_anterior
  FROM por_mes
)
SELECT strftime(mes, '%Y-%m') AS mes,
       pedidos,
       mes_anterior,
       ROUND(100.0 * (pedidos - mes_anterior) / mes_anterior, 1) AS variacao_pct
FROM com_anterior
WHERE categoria = 'Esporte'
ORDER BY mes;
