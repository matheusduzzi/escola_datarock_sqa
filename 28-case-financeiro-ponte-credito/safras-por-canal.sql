-- A mesma régua das três primeiras parcelas, separada por canal, só nas safras maduras.
WITH corte AS (
    SELECT DATE '2026-06-30' AS dia
),
dias AS (
    SELECT p.id_contrato, p.numero_parcela, p.vencimento,
           date_diff('day', p.vencimento, COALESCE(p.data_pagamento, c.dia)) AS dias_atraso
    FROM parcelas p CROSS JOIN corte c
),
por_contrato AS (
    SELECT k.id_contrato, strftime(k.data_contrato, '%Y-%m') AS safra, pr.canal,
           MAX(CASE WHEN d.numero_parcela <= 3 AND d.dias_atraso > 30 THEN 1 ELSE 0 END) AS atrasou,
           MAX(d.vencimento) FILTER (WHERE d.numero_parcela = 3) AS vence_a_3a
    FROM contratos k
    JOIN propostas pr USING (id_proposta)
    JOIN dias d USING (id_contrato)
    GROUP BY k.id_contrato, safra, pr.canal
),
maduras AS (
    SELECT safra
    FROM por_contrato
    GROUP BY safra
    HAVING MAX(vence_a_3a) + INTERVAL 31 DAY <= (SELECT dia FROM corte)
)
SELECT safra,
       COUNT(*) FILTER (WHERE canal = 'web') AS contratos_web,
       ROUND(100.0 * SUM(atrasou) FILTER (WHERE canal = 'web') / COUNT(*) FILTER (WHERE canal = 'web'), 1) AS pct_web,
       COUNT(*) FILTER (WHERE canal = 'parceiro') AS contratos_parceiro,
       ROUND(100.0 * SUM(atrasou) FILTER (WHERE canal = 'parceiro') / COUNT(*) FILTER (WHERE canal = 'parceiro'), 1) AS pct_parceiro
FROM por_contrato
WHERE safra IN (SELECT safra FROM maduras)
GROUP BY safra
ORDER BY safra;
