-- Produtos do romaneio que não aparecem em nenhuma doca: EXCEPT.
WITH bipadas AS (
    SELECT produto FROM doca1
    UNION ALL
    SELECT produto FROM doca2
)
SELECT produto FROM romaneio
EXCEPT
SELECT produto FROM bipadas
ORDER BY produto;
