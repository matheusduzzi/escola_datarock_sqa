-- A consulta do Otávio para o exercício: atraso na 1ª parcela, por safra e canal.
SELECT strftime(k.data_contrato, '%Y-%m') AS safra, pr.canal,
       COUNT(*) AS contratos,
       COUNT(*) FILTER (WHERE p.data_pagamento IS NULL) AS primeira_em_atraso,
       ROUND(100.0 * COUNT(*) FILTER (WHERE p.data_pagamento IS NULL) / COUNT(*), 1) AS pct
FROM contratos k
JOIN propostas pr USING (id_proposta)
JOIN parcelas p ON p.id_contrato = k.id_contrato AND p.numero_parcela = 1
GROUP BY safra, pr.canal
ORDER BY pr.canal, safra;
