-- Quantas caixas de cada produto há em cada lista.
-- romaneio: o que o fornecedor diz que mandou. doca1 e doca2: o que o leitor bipou em cada doca.
-- A CTE produtos junta os nomes das três listas com UNION: cada produto aparece uma vez.
WITH produtos AS (
    SELECT produto FROM romaneio
    UNION
    SELECT produto FROM doca1
    UNION
    SELECT produto FROM doca2
)
SELECT p.produto,
       (SELECT COUNT(*) FROM romaneio r WHERE r.produto = p.produto) AS romaneio,
       (SELECT COUNT(*) FROM doca1 d WHERE d.produto = p.produto)    AS doca1,
       (SELECT COUNT(*) FROM doca2 d WHERE d.produto = p.produto)    AS doca2
FROM produtos p
ORDER BY romaneio DESC, p.produto;
