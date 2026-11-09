-- Abril teve registro de pedidos? E de Esporte?
WITH abril AS (
  SELECT *
  FROM pedidos
  WHERE data_hora_pedido >= TIMESTAMP '2026-04-01'
    AND data_hora_pedido <  TIMESTAMP '2026-05-01'
)
SELECT o_que, n
FROM (
  SELECT 1 AS ordem, 'pedidos em abril' AS o_que, COUNT(*) AS n FROM abril
  UNION ALL
  SELECT 2, 'dias de abril com algum pedido', COUNT(DISTINCT CAST(data_hora_pedido AS DATE)) FROM abril
  UNION ALL
  SELECT 3, 'produtos de Esporte no catálogo', COUNT(*) FROM produtos WHERE categoria = 'Esporte'
  UNION ALL
  SELECT 4, 'itens de Esporte vendidos em abril', COUNT(*)
  FROM abril JOIN itens_pedido USING (id_pedido) JOIN produtos USING (id_produto)
  WHERE categoria = 'Esporte'
)
ORDER BY ordem;
