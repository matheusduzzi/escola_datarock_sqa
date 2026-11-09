-- A consulta do Caio: viagens e frete por quinzena, de janeiro a abril, pela data da tentativa.
-- A primeira quinzena vai do dia 1 ao dia 15, a segunda do dia 16 ao fim do mês.
WITH quinzenas AS (
    SELECT * FROM (VALUES
        ('2026-01 q1', DATE '2026-01-01', DATE '2026-01-16'),
        ('2026-01 q2', DATE '2026-01-16', DATE '2026-02-01'),
        ('2026-02 q1', DATE '2026-02-01', DATE '2026-02-16'),
        ('2026-02 q2', DATE '2026-02-16', DATE '2026-03-01'),
        ('2026-03 q1', DATE '2026-03-01', DATE '2026-03-16'),
        ('2026-03 q2', DATE '2026-03-16', DATE '2026-04-01'),
        ('2026-04 q1', DATE '2026-04-01', DATE '2026-04-16'),
        ('2026-04 q2', DATE '2026-04-16', DATE '2026-05-01')
    ) AS t(quinzena, inicio, fim)
)
SELECT q.quinzena, COUNT(e.id_entrega) AS viagens, ROUND(SUM(e.custo_frete), 2) AS frete
FROM quinzenas AS q
LEFT JOIN entregas AS e ON e.data_tentativa BETWEEN q.inicio AND q.fim
GROUP BY q.quinzena
ORDER BY q.quinzena;
