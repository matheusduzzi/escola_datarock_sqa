-- As duas docas empilhadas com UNION ALL: uma linha por caixa bipada.
SELECT produto FROM doca1
UNION ALL
SELECT produto FROM doca2
ORDER BY produto;
