-- A lista para a reclamação: por produto, quantas caixas faltaram e quantas vieram a mais.
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
), produtos AS (
    SELECT produto FROM faltou
    UNION
    SELECT produto FROM a_mais
)
SELECT p.produto,
       (SELECT COUNT(*) FROM faltou f WHERE f.produto = p.produto) AS faltou,
       (SELECT COUNT(*) FROM a_mais a WHERE a.produto = p.produto) AS veio_a_mais
FROM produtos p
ORDER BY p.produto;
