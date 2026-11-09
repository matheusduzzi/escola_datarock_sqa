-- Quantas linhas da loja acharam um cliente do site, por regra.
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
SELECT regra, COUNT(DISTINCT id_loja) AS linhas_da_loja, COUNT(DISTINCT id_cliente) AS clientes_do_site
FROM pares
GROUP BY regra
ORDER BY linhas_da_loja DESC;
