-- Produtos que estão no romaneio e foram bipados: INTERSECT.
WITH bipadas AS (
    SELECT produto FROM doca1
    UNION ALL
    SELECT produto FROM doca2
)
SELECT produto FROM romaneio
INTERSECT
SELECT produto FROM bipadas
ORDER BY produto;
