-- O desembolso de cada mês, pela data em que o dinheiro saiu, e o acumulado desde julho de 2025.
WITH por_mes AS (
    SELECT strftime(data_desembolso, '%Y-%m') AS mes, SUM(valor) AS desembolsado
    FROM desembolsos
    GROUP BY mes
)
SELECT mes, desembolsado,
       SUM(desembolsado) OVER (ORDER BY mes ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS acumulado
FROM por_mes
ORDER BY mes;
