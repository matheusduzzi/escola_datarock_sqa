-- As mesmas duas docas com UNION: as linhas repetidas viram uma só.
SELECT produto FROM doca1
UNION
SELECT produto FROM doca2
ORDER BY produto;
