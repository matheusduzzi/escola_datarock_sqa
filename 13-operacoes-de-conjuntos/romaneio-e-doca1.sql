-- Prática, pedido 2. Escreva a sua previsão antes de rodar.
-- Depois troque INTERSECT ALL por INTERSECT, preveja de novo e rode.
SELECT produto FROM romaneio
INTERSECT ALL
SELECT produto FROM doca1
ORDER BY produto;
