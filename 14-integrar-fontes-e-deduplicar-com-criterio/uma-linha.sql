-- Os pares de algumas linhas da loja com o site. Troque os ids da lista para ver outras.
WITH linhas AS (
    SELECT 'site' AS origem, 1 AS prioridade, CAST(id_cliente AS VARCHAR) AS id_origem,
           id_cliente, nome, email, telefone, cidade, atualizado_em
    FROM site
    UNION ALL
    SELECT 'loja', 2, id_loja, NULL, nome, email, telefone, cidade, atualizado_em
    FROM loja
),
digitos AS (
    SELECT *, regexp_replace(telefone, '[^0-9]', '', 'g') AS so_digitos
    FROM linhas
),
chaves AS (
    SELECT origem, prioridade, id_origem, id_cliente, nome, cidade, atualizado_em,
           NULLIF(lower(trim(email)), '') AS email_chave,
           CASE WHEN length(so_digitos) = 13 AND so_digitos LIKE '55%' THEN substr(so_digitos, 3)
                ELSE NULLIF(so_digitos, '') END AS tel_chave,
           lower(strip_accents(split_part(trim(nome), ' ', 1))) AS primeiro_nome
    FROM digitos
),
pares AS (
    -- cada linha da loja com cada cliente do site que tem o mesmo e-mail ou o mesmo telefone
    SELECT l.id_origem AS id_loja, s.id_cliente,
           CASE WHEN l.email_chave = s.email_chave THEN 'e-mail'
                WHEN l.primeiro_nome = s.primeiro_nome THEN 'telefone e nome'
                ELSE 'telefone de outra pessoa' END AS regra
    FROM chaves l
    JOIN chaves s ON s.origem = 'site'
                 AND (l.email_chave = s.email_chave OR l.tel_chave = s.tel_chave)
    WHERE l.origem = 'loja'
)
SELECT l.id_origem AS id_loja, l.nome, p.id_cliente, s.nome AS nome_no_site, p.regra
FROM chaves l
LEFT JOIN pares p ON p.id_loja = l.id_origem
LEFT JOIN chaves s ON s.origem = 'site' AND s.id_cliente = p.id_cliente
WHERE l.id_origem IN ('L12', 'L18', 'L21')
ORDER BY l.id_origem;
