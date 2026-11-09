-- A régua das três primeiras parcelas em todas as safras, sem olhar se a safra já teve tempo.
WITH dias AS (
    SELECT id_contrato, numero_parcela,
           date_diff('day', vencimento, COALESCE(data_pagamento, DATE '2026-06-30')) AS dias_atraso
    FROM parcelas
),
por_contrato AS (
    SELECT id_contrato, MAX(CASE WHEN numero_parcela <= 3 AND dias_atraso > 30 THEN 1 ELSE 0 END) AS atrasou
    FROM dias
    GROUP BY id_contrato
)
SELECT strftime(k.data_contrato, '%Y-%m') AS safra,
       ROUND(100.0 * SUM(c.atrasou) / COUNT(*), 1) AS pct_atraso
FROM contratos k
JOIN por_contrato c USING (id_contrato)
WHERE k.data_contrato >= DATE '2026-01-01'
GROUP BY safra
ORDER BY safra;
