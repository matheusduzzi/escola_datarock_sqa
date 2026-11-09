-- A lista para a reclamação: caixa por caixa, o que faltou e o que veio a mais.
WITH bipadas AS (
    SELECT produto FROM doca1
    UNION ALL
    SELECT produto FROM doca2
), faltou AS (
    SELECT produto FROM romaneio
    EXCEPT ALL
    SELECT produto FROM bipadas
), a_mais AS (
    SELECT produto FROM bipadas
    EXCEPT ALL
    SELECT produto FROM romaneio
)
SELECT 'faltou' AS diferenca, produto, COUNT(*) AS caixas FROM faltou GROUP BY produto
UNION ALL
SELECT 'veio a mais', produto, COUNT(*) FROM a_mais GROUP BY produto
ORDER BY diferenca, produto;
