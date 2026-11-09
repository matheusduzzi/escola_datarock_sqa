-- Em cada safra, quantas parcelas já venceram há mais de 30 dias na data da extração (30/06/2026).
SELECT strftime(k.data_contrato, '%Y-%m') AS safra,
       MIN(p.vencimento) FILTER (WHERE p.numero_parcela = 1) AS vence_a_1a,
       MAX(p.numero_parcela) FILTER (WHERE p.vencimento + INTERVAL 31 DAY <= DATE '2026-06-30') AS parcelas_julgaveis
FROM contratos k
JOIN parcelas p USING (id_contrato)
GROUP BY safra
ORDER BY safra;
