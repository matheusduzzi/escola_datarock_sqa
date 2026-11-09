-- Perguntas com resposta conhecida sobre a tabela de safras. As etapas são as do safras.sql.
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
SELECT 'contratos na tabela de safras' AS o_que, (SELECT SUM(contratos) FROM por_safra) AS valor
UNION ALL SELECT 'contratos na tabela contratos', (SELECT COUNT(*) FROM contratos)
UNION ALL SELECT 'safras maduras', (SELECT COUNT(*) FROM por_safra WHERE madura)
UNION ALL SELECT 'contratos com atraso nas maduras', (SELECT SUM(com_atraso) FROM por_safra WHERE madura)
UNION ALL SELECT 'parcelas com atraso nas maduras',
       (SELECT COUNT(*) FROM dias d JOIN por_contrato c USING (id_contrato)
        JOIN por_safra s USING (safra)
        WHERE s.madura AND d.numero_parcela <= 3 AND d.dias_atraso > 30)
UNION ALL SELECT 'contratos com duas ou mais', (SELECT COUNT(*) FROM (
        SELECT d.id_contrato FROM dias d JOIN por_contrato c USING (id_contrato) JOIN por_safra s USING (safra)
        WHERE s.madura AND d.numero_parcela <= 3 AND d.dias_atraso > 30
        GROUP BY d.id_contrato HAVING COUNT(*) >= 2));
