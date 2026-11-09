-- O outro sentido: caixas bipadas que o romaneio não tem.
WITH bipadas AS (
    SELECT produto FROM doca1
    UNION ALL
    SELECT produto FROM doca2
)
SELECT produto FROM bipadas
EXCEPT ALL
SELECT produto FROM romaneio
ORDER BY produto;
