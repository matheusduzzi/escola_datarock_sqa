-- O que as operações de conjunto fazem com o valor vazio (NULL).
-- Duas caixas com a etiqueta ilegível na doca e uma linha sem produto no romaneio.
WITH bipadas(produto) AS (VALUES ('Panela'), (NULL), (NULL)),
     romaneio_teste(produto) AS (VALUES ('Panela'), (NULL))
SELECT 'UNION'      AS operacao, COUNT(*) AS linhas, COUNT(*) - COUNT(produto) AS vazias
FROM (SELECT produto FROM bipadas UNION SELECT produto FROM romaneio_teste)
UNION ALL
SELECT 'EXCEPT ALL', COUNT(*), COUNT(*) - COUNT(produto)
FROM (SELECT produto FROM bipadas EXCEPT ALL SELECT produto FROM romaneio_teste)
UNION ALL
SELECT 'INTERSECT', COUNT(*), COUNT(*) - COUNT(produto)
FROM (SELECT produto FROM bipadas INTERSECT SELECT produto FROM romaneio_teste)
UNION ALL
SELECT 'JOIN com =', COUNT(*), COUNT(*) - COUNT(b.produto)
FROM bipadas b JOIN romaneio_teste r ON r.produto = b.produto;
