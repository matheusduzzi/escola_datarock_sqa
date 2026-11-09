-- Esporte com uma tabela de meses de janeiro a dezembro e LEFT JOIN.
-- Uma coluna sem COALESCE e outra com COALESCE(..., 0).
WITH meses AS (
  SELECT strftime(inicio, '%Y-%m') AS mes
  FROM range(TIMESTAMP '2026-01-01', TIMESTAMP '2027-01-01', INTERVAL 1 MONTH) AS t(inicio)
),
esporte AS (
  SELECT strftime(p.data_hora_pedido, '%Y-%m') AS mes,
         COUNT(DISTINCT p.id_pedido) AS pedidos
  FROM pedidos p
  JOIN itens_pedido i USING (id_pedido)
  JOIN produtos d USING (id_produto)
  WHERE d.categoria = 'Esporte'
  GROUP BY mes
)
SELECT m.mes,
       e.pedidos AS sem_coalesce,
       COALESCE(e.pedidos, 0) AS com_coalesce
FROM meses m
LEFT JOIN esporte e USING (mes)
ORDER BY m.mes;
