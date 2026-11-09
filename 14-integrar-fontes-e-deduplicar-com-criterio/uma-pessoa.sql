-- As linhas da Ana Paula Souza nas duas listas, como chegaram.
SELECT 'site' AS origem, CAST(id_cliente AS VARCHAR) AS id_origem, nome, email, telefone, atualizado_em
FROM site
WHERE id_cliente = 3
UNION ALL
SELECT 'loja', id_loja, nome, email, telefone, atualizado_em
FROM loja
WHERE id_loja IN ('L01', 'L17')
ORDER BY origem DESC, id_origem;
