-- Frete por mês da tentativa de entrega, ida e devolução.
-- As tentativas que ainda não aconteceram (data_tentativa vazia) ficam de fora.
SELECT strftime(data_tentativa, '%Y-%m') AS mes,
       COUNT(*) AS viagens,
       COUNT(custo_frete) AS com_custo,
       COUNT(*) - COUNT(custo_frete) AS sem_custo,
       ROUND(SUM(custo_frete), 2) AS soma,
       ROUND(AVG(custo_frete), 2) AS media,
       ROUND(AVG(COALESCE(custo_frete, 0)), 2) AS media_com_zero
FROM entregas
WHERE data_tentativa IS NOT NULL
GROUP BY mes
ORDER BY mes;
