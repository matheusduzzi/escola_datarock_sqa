-- A consulta do Caio para a série semanal da Lúcia: pedidos por semana e categoria,
-- de segunda a domingo, pela data do pedido.
-- A última parte junta as semanas de cada categoria, para caber na tela.
WITH caio AS (
  SELECT CAST(date_trunc('week', p.data_hora_pedido) AS DATE) AS semana,
         d.categoria,
         COUNT(*) AS pedidos
  FROM pedidos p
  JOIN itens_pedido i USING (id_pedido)
  JOIN produtos d USING (id_produto)
  GROUP BY 1, 2
)
SELECT categoria,
       COUNT(*) AS semanas,
       MIN(semana) AS primeira,
       MAX(semana) AS ultima,
       SUM(pedidos) AS soma,
       ROUND(AVG(pedidos), 1) AS media_semanal
FROM caio
GROUP BY categoria
ORDER BY categoria;
