-- Caixas que bateram: INTERSECT ALL junta uma caixa do romaneio com uma caixa bipada.
WITH bipadas AS (
    SELECT produto FROM doca1
    UNION ALL
    SELECT produto FROM doca2
)
SELECT produto FROM romaneio
INTERSECT ALL
SELECT produto FROM bipadas
ORDER BY produto;
