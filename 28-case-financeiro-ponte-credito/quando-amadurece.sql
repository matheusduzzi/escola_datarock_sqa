-- Para cada safra ainda não madura: quando vence a 3ª parcela e a partir de que dia de extração ela entra.
WITH terceira AS (
    SELECT strftime(k.data_contrato, '%Y-%m') AS safra, MAX(p.vencimento) AS vence_a_3a
    FROM contratos k
    JOIN parcelas p USING (id_contrato)
    WHERE p.numero_parcela = 3
    GROUP BY safra
)
SELECT safra, vence_a_3a, CAST(vence_a_3a + INTERVAL 31 DAY AS DATE) AS entra_a_partir_de
FROM terceira
WHERE vence_a_3a + INTERVAL 31 DAY > DATE '2026-06-30'
ORDER BY safra;
