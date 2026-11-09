-- A consulta do Caio para a Marta: viagens, devoluções e frete por semana,
-- de segunda a domingo, pela data da tentativa de entrega.
SELECT CAST(date_trunc('week', data_tentativa) AS DATE) AS semana,
       COUNT(*) FILTER (WHERE tipo = 'ida') AS viagens,
       COUNT(*) FILTER (WHERE tipo = 'devolucao') AS devolucoes,
       ROUND(SUM(COALESCE(custo_frete, 0)), 2) AS frete,
       ROUND(SUM(COALESCE(custo_frete, 0)) / COUNT(*), 2) AS frete_por_viagem
FROM entregas
WHERE data_tentativa IS NOT NULL
GROUP BY semana
ORDER BY semana;
