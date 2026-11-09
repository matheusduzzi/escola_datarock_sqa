-- Atraso de mais de 30 dias em alguma das três primeiras parcelas, por safra.
-- Só entra na comparação a safra em que a 3ª parcela já venceu há mais de 30 dias.
WITH corte AS (
    SELECT DATE '2026-06-30' AS dia
),
dias AS (
    SELECT p.id_contrato, p.numero_parcela, p.vencimento,
           date_diff('day', p.vencimento, COALESCE(p.data_pagamento, c.dia)) AS dias_atraso
    FROM parcelas p CROSS JOIN corte c
),
por_contrato AS (
    SELECT k.id_contrato, strftime(k.data_contrato, '%Y-%m') AS safra,
           MAX(CASE WHEN d.numero_parcela <= 3 AND d.dias_atraso > 30 THEN 1 ELSE 0 END) AS atrasou,
           MAX(d.vencimento) FILTER (WHERE d.numero_parcela = 3) AS vence_a_3a
    FROM contratos k
    JOIN dias d USING (id_contrato)
    GROUP BY k.id_contrato, safra
),
por_safra AS (
    SELECT safra, COUNT(*) AS contratos, SUM(atrasou) AS com_atraso,
           MAX(vence_a_3a) + INTERVAL 31 DAY <= (SELECT dia FROM corte) AS madura
    FROM por_contrato
    GROUP BY safra
)
SELECT safra, contratos,
       CASE WHEN madura THEN com_atraso END AS com_atraso,
       CASE WHEN madura THEN ROUND(100.0 * com_atraso / contratos, 1) END AS pct_atraso,
       CASE WHEN madura THEN 'madura' ELSE 'ainda não' END AS comparar
FROM por_safra
ORDER BY safra;
