-- A regra que o Caio sugeriu: mesmo nome completo e mesma cidade também é a mesma pessoa.
-- Mostra só os pares que essa regra acrescenta, os que a regra da aula não juntava.
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
SELECT l.id_origem AS id_loja, l.nome, s.id_cliente, l.cidade,
       l.email_chave AS email_loja, s.email_chave AS email_site,
       l.tel_chave AS tel_loja, s.tel_chave AS tel_site
FROM chaves l
JOIN chaves s ON s.origem = 'site'
             AND lower(strip_accents(trim(l.nome))) = lower(strip_accents(trim(s.nome)))
             AND l.cidade = s.cidade
WHERE l.origem = 'loja'
  AND NOT EXISTS (SELECT 1 FROM pares p
                  WHERE p.id_loja = l.id_origem AND p.id_cliente = s.id_cliente
                    AND p.regra <> 'telefone de outra pessoa')
ORDER BY l.id_origem;
