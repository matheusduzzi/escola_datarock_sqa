-- A conta sem operação de conjunto: m caixas no romaneio, n bipadas, por produto.
-- As colunas da direita são o que cada operação deve dar, calculado a partir de m e n.
WITH todas AS (
    SELECT 'romaneio' AS lista, produto FROM romaneio
    UNION ALL
    SELECT 'bipada', produto FROM doca1
    UNION ALL
    SELECT 'bipada', produto FROM doca2
), contagem AS (
    SELECT produto,
           COUNT(*) FILTER (WHERE lista = 'romaneio') AS m,
           COUNT(*) FILTER (WHERE lista = 'bipada')   AS n
    FROM todas
    GROUP BY produto
)
SELECT produto, m, n,
       LEAST(m, n)          AS bateu,
       GREATEST(m - n, 0)   AS faltou,
       GREATEST(n - m, 0)   AS a_mais
FROM contagem
ORDER BY m DESC, produto;
