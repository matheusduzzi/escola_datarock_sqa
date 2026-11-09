-- A grade com os itens juntados direto, sem somar antes, e três jeitos de contar.
-- Mostra três linhas da grade: Esporte em abril, Esporte em maio e Beleza em maio.
WITH meses AS (
  SELECT CAST(inicio AS DATE) AS mes
  FROM range(TIMESTAMP '2026-01-01', TIMESTAMP '2026-07-01', INTERVAL 1 MONTH) AS t(inicio)
),
categorias AS (
  SELECT DISTINCT categoria FROM produtos
),
grade AS (
  SELECT m.mes, c.categoria FROM meses m CROSS JOIN categorias c
),
itens AS (
  SELECT CAST(date_trunc('month', p.data_hora_pedido) AS DATE) AS mes,
         d.categoria, p.id_pedido, i.n_item
  FROM pedidos p
  JOIN itens_pedido i USING (id_pedido)
  JOIN produtos d USING (id_produto)
)
SELECT strftime(g.mes, '%Y-%m') AS mes,
       g.categoria,
       COUNT(*) AS count_estrela,
       COUNT(it.n_item) AS itens,
       COUNT(DISTINCT it.id_pedido) AS pedidos
FROM grade g
LEFT JOIN itens it ON it.mes = g.mes AND it.categoria = g.categoria
WHERE (g.categoria = 'Esporte' AND g.mes IN (DATE '2026-04-01', DATE '2026-05-01'))
   OR (g.categoria = 'Beleza' AND g.mes = DATE '2026-05-01')
GROUP BY g.mes, g.categoria
ORDER BY g.categoria DESC, g.mes;
