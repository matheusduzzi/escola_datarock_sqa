-- Prática, pedido 3. A ideia era tirar do romaneio as caixas das duas docas.
-- Escreva a sua previsão antes de rodar.
SELECT COUNT(*) AS linhas
FROM (
    SELECT produto FROM romaneio
    EXCEPT ALL
    SELECT produto FROM doca1
    UNION ALL
    SELECT produto FROM doca2
);
