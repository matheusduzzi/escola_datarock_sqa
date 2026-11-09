-- A cobertura de cada mês: um calendário de dias, do primeiro ao último dia que a base tem,
-- agrupado por mês. Os limites saem dos próprios pedidos, e não de datas escritas à mão.
WITH limites AS (
  SELECT CAST(MIN(data_hora_pedido) AS DATE) AS primeiro_dia,
         CAST(MAX(data_hora_pedido) AS DATE) AS ultimo_dia
  FROM pedidos
),
dias AS (
  SELECT CAST(t.dia AS DATE) AS dia
  FROM limites, range(limites.primeiro_dia, limites.ultimo_dia + 1, INTERVAL 1 DAY) AS t(dia)
)
SELECT strftime(date_trunc('month', dia), '%Y-%m') AS mes,
       day(last_day(MIN(dia))) AS dias_no_mes,
       COUNT(*) AS dias_na_base,
       MIN(dia) AS primeiro,
       MAX(dia) AS ultimo,
       CASE WHEN COUNT(*) = day(last_day(MIN(dia))) THEN 'completo' ELSE 'parcial' END AS situacao
FROM dias
GROUP BY 1
ORDER BY 1;
