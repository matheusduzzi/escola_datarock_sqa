-- Quanto o canal parceiro pesa no mês e no acumulado.
-- A janela vê os dois canais; o filtro do parceiro fica na última etapa, depois dela.
WITH por_canal AS (
    SELECT strftime(d.data_desembolso, '%Y-%m') AS mes, p.canal, SUM(d.valor) AS desembolsado
    FROM desembolsos d
    JOIN contratos k USING (id_contrato)
    JOIN propostas p USING (id_proposta)
    GROUP BY mes, p.canal
),
com_janelas AS (
    SELECT mes, canal, desembolsado,
           SUM(desembolsado) OVER (PARTITION BY mes) AS total_mes,
           SUM(desembolsado) OVER (PARTITION BY canal ORDER BY mes
                                   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS acumulado_canal,
           SUM(desembolsado) OVER (ORDER BY mes RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS acumulado_total
    FROM por_canal
)
SELECT mes, desembolsado AS parceiro, total_mes,
       ROUND(100.0 * desembolsado / total_mes, 1) AS pct_mes,
       acumulado_canal AS acumulado_parceiro,
       ROUND(100.0 * acumulado_canal / acumulado_total, 1) AS pct_acumulado
FROM com_janelas
WHERE canal = 'parceiro'
ORDER BY mes;
