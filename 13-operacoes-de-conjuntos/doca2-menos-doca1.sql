-- Prática, pedido 1. Escreva a sua previsão antes de rodar.
-- Depois troque EXCEPT por EXCEPT ALL, preveja de novo e rode.
SELECT produto FROM doca2
EXCEPT
SELECT produto FROM doca1
ORDER BY produto;
