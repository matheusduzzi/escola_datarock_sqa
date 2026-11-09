-- Perguntas com resposta conhecida antes de mandar a tabela.
WITH por_mes AS (
    SELECT strftime(data_desembolso, '%Y-%m') AS mes, SUM(valor) AS desembolsado
    FROM desembolsos GROUP BY mes
),
acumulado AS (
    SELECT mes, SUM(desembolsado) OVER (ORDER BY mes ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS acumulado
    FROM por_mes
),
por_canal AS (
    SELECT strftime(d.data_desembolso, '%Y-%m') AS mes, p.canal, SUM(d.valor) AS desembolsado
    FROM desembolsos d JOIN contratos k USING (id_contrato) JOIN propostas p USING (id_proposta)
    GROUP BY mes, p.canal
),
participacao AS (
    SELECT mes, canal, desembolsado / SUM(desembolsado) OVER (PARTITION BY mes) AS fatia
    FROM por_canal
)
SELECT 'total da tabela desembolsos' AS o_que, (SELECT SUM(valor) FROM desembolsos) AS valor
UNION ALL
SELECT 'acumulado de 2026-06', (SELECT acumulado FROM acumulado WHERE mes = '2026-06')
UNION ALL
SELECT 'soma por safra (mês do contrato)',
       (SELECT SUM(d.valor) FROM desembolsos d JOIN contratos k USING (id_contrato))
UNION ALL
SELECT 'acumulado web + parceiro', (SELECT SUM(desembolsado) FROM por_canal)
UNION ALL
SELECT 'meses cuja participação não soma 100%',
       (SELECT COUNT(*) FROM (SELECT mes FROM participacao GROUP BY mes HAVING ABS(SUM(fatia) - 1) > 1e-9))
UNION ALL
SELECT 'desembolsos sem contrato',
       (SELECT COUNT(*) FROM desembolsos d WHERE NOT EXISTS (SELECT 1 FROM contratos k WHERE k.id_contrato = d.id_contrato))
UNION ALL
SELECT 'contratos sem desembolso',
       (SELECT COUNT(*) FROM contratos k WHERE NOT EXISTS (SELECT 1 FROM desembolsos d WHERE d.id_contrato = k.id_contrato));
