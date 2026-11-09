-- Três totais que deveriam conversar: o do JOIN, o que foi liberado e o que foi contratado.
SELECT 'soma do JOIN' AS o_que, SUM(k.valor_contratado) AS valor
FROM contratos k JOIN desembolsos d USING (id_contrato)
UNION ALL
SELECT 'liberado (desembolsos)', SUM(valor) FROM desembolsos
UNION ALL
SELECT 'contratado (contratos)', SUM(valor_contratado) FROM contratos
UNION ALL
SELECT 'contratos liberados em duas partes',
       COUNT(*) FROM (SELECT id_contrato FROM desembolsos GROUP BY id_contrato HAVING COUNT(*) = 2)
UNION ALL
SELECT 'contratos com a segunda parte a liberar',
       COUNT(*) FROM (SELECT k.id_contrato
                      FROM contratos k JOIN desembolsos d USING (id_contrato)
                      GROUP BY k.id_contrato, k.valor_contratado
                      HAVING SUM(d.valor) < k.valor_contratado);
