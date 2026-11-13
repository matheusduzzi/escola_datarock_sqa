-- A conta por produto: m caixas no romaneio, n bipadas nas duas docas.
-- As colunas da direita são o que cada operação deve dar, calculado a partir de m e n.
WITH produtos AS (
    SELECT produto FROM romaneio
    UNION
    SELECT produto FROM doca1
    UNION
    SELECT produto FROM doca2
), contagem AS (
    SELECT p.produto,
           (SELECT COUNT(*) FROM romaneio r WHERE r.produto = p.produto) AS m,
           (SELECT COUNT(*) FROM doca1 d WHERE d.produto = p.produto)
         + (SELECT COUNT(*) FROM doca2 d WHERE d.produto = p.produto)    AS n
    FROM produtos p
)
SELECT produto, m, n,
       LEAST(m, n)          AS bateu,
       GREATEST(m - n, 0)   AS faltou,
       GREATEST(n - m, 0)   AS a_mais
FROM contagem
ORDER BY m DESC, produto;
