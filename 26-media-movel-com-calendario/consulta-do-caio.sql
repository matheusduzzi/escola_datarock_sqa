-- A consulta que o Caio mandou para a Marta: viagens e frete por dia de tentativa,
-- com a média dos últimos 7 dias. Uma linha por dia que teve viagem.
WITH por_dia AS (
  SELECT data_tentativa AS dia,
         COUNT(*) AS viagens,
         SUM(custo_frete) AS frete
  FROM entregas
  WHERE data_tentativa IS NOT NULL
  GROUP BY data_tentativa
)
SELECT dia,
       viagens,
       ROUND(frete, 2) AS frete,
       ROUND(AVG(viagens) OVER w, 2) AS media_viagens_7_dias,
       ROUND(AVG(frete) OVER w, 2) AS media_frete_7_dias
FROM por_dia
WINDOW w AS (ORDER BY dia ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
ORDER BY dia;
