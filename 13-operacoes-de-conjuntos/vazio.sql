-- O que as operações de conjunto fazem com o valor vazio (NULL).
-- Duas caixas com a etiqueta ilegível na doca e uma linha sem produto no romaneio.
WITH bipadas(produto) AS (VALUES ('Panela'), (NULL), (NULL)),
     romaneio_teste(produto) AS (VALUES ('Panela'), (NULL)),
     com_union AS (
         SELECT produto FROM bipadas
         UNION
         SELECT produto FROM romaneio_teste
     ),
     com_except_all AS (
         SELECT produto FROM bipadas
         EXCEPT ALL
         SELECT produto FROM romaneio_teste
     ),
     com_intersect AS (
         SELECT produto FROM bipadas
         INTERSECT
         SELECT produto FROM romaneio_teste
     ),
     com_join AS (
         SELECT b.produto FROM bipadas b JOIN romaneio_teste r ON r.produto = b.produto
     )
SELECT operacao, linhas, vazias
FROM (VALUES
    (1, 'UNION',      (SELECT COUNT(*) FROM com_union),      (SELECT COUNT(*) - COUNT(produto) FROM com_union)),
    (2, 'EXCEPT ALL', (SELECT COUNT(*) FROM com_except_all), (SELECT COUNT(*) - COUNT(produto) FROM com_except_all)),
    (3, 'INTERSECT',  (SELECT COUNT(*) FROM com_intersect),  (SELECT COUNT(*) - COUNT(produto) FROM com_intersect)),
    (4, 'JOIN com =', (SELECT COUNT(*) FROM com_join),       (SELECT COUNT(*) - COUNT(produto) FROM com_join))
) AS resumo(ordem, operacao, linhas, vazias)
ORDER BY ordem;
