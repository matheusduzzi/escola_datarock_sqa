-- As mesmas linhas, com o e-mail, o telefone e o primeiro nome limpos.
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
)
SELECT origem, id_origem, email_chave, tel_chave, primeiro_nome
FROM chaves
WHERE id_origem IN ('3', 'L01', 'L17', 'L04')
ORDER BY origem DESC, id_origem;
