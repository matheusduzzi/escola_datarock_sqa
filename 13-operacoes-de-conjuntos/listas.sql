-- Quantas caixas de cada produto há em cada lista.
-- romaneio: o que o fornecedor diz que mandou. doca1 e doca2: o que o leitor bipou em cada doca.
WITH todas AS (
    SELECT 'romaneio' AS lista, produto FROM romaneio
    UNION ALL
    SELECT 'doca1', produto FROM doca1
    UNION ALL
    SELECT 'doca2', produto FROM doca2
)
SELECT produto,
       COUNT(*) FILTER (WHERE lista = 'romaneio') AS romaneio,
       COUNT(*) FILTER (WHERE lista = 'doca1')    AS doca1,
       COUNT(*) FILTER (WHERE lista = 'doca2')    AS doca2
FROM todas
GROUP BY produto
ORDER BY romaneio DESC, produto;
