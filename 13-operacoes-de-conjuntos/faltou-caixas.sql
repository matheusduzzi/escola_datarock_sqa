-- Caixas do romaneio que não foram bipadas: EXCEPT ALL tira uma caixa bipada para cada caixa do romaneio.
WITH bipadas AS (
    SELECT produto FROM doca1
    UNION ALL
    SELECT produto FROM doca2
)
SELECT produto FROM romaneio
EXCEPT ALL
SELECT produto FROM bipadas
ORDER BY produto;
