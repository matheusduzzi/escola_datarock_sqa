-- A consulta que o Caio mandou para a Lúcia: pedidos por mês e categoria,
-- com a média dos últimos 3 meses de cada categoria.
-- A última parte mostra só Esporte, para caber na tela.
WITH fatos AS (
  SELECT CAST(date_trunc('month', p.data_hora_pedido) AS DATE) AS mes,
         d.categoria,
         COUNT(DISTINCT p.id_pedido) AS pedidos
  FROM pedidos p
  JOIN itens_pedido i USING (id_pedido)
  JOIN produtos d USING (id_produto)
  GROUP BY 1, 2
),
media AS (
  SELECT mes, categoria, pedidos,
         ROUND(AVG(pedidos) OVER (PARTITION BY categoria ORDER BY mes
                                  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS media_3_meses
  FROM fatos
)
SELECT strftime(mes, '%Y-%m') AS mes, pedidos, media_3_meses
FROM media
WHERE categoria = 'Esporte'
ORDER BY mes;
