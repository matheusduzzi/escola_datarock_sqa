-- Contratado e liberado por mês do contrato, e o que ainda falta liberar.
WITH liberado AS (
    SELECT id_contrato, SUM(valor) AS liberado
    FROM desembolsos
    GROUP BY id_contrato
)
SELECT strftime(k.data_contrato, '%Y-%m') AS safra,
       SUM(k.valor_contratado) AS contratado,
       SUM(l.liberado) AS liberado,
       SUM(k.valor_contratado - l.liberado) AS a_liberar,
       COUNT(*) FILTER (WHERE l.liberado < k.valor_contratado) AS contratos_a_liberar
FROM contratos k
JOIN liberado l USING (id_contrato)
GROUP BY safra
HAVING SUM(k.valor_contratado - l.liberado) > 0
ORDER BY safra;
