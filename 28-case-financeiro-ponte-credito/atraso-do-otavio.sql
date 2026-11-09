-- A tabela do Otávio: contratos com alguma parcela em atraso de mais de 30 dias, por safra.
-- Safra é o mês do contrato. A data da extração é 30/06/2026.
WITH dias AS (
    SELECT id_contrato,
           date_diff('day', vencimento, COALESCE(data_pagamento, DATE '2026-06-30')) AS dias_atraso
    FROM parcelas
),
por_contrato AS (
    SELECT id_contrato, MAX(CASE WHEN dias_atraso > 30 THEN 1 ELSE 0 END) AS atrasou
    FROM dias
    GROUP BY id_contrato
)
SELECT strftime(k.data_contrato, '%Y-%m') AS safra,
       COUNT(*) AS contratos,
       SUM(c.atrasou) AS com_atraso,
       ROUND(100.0 * SUM(c.atrasou) / COUNT(*), 1) AS pct_atraso
FROM contratos k
JOIN por_contrato c USING (id_contrato)
GROUP BY safra
ORDER BY safra;
