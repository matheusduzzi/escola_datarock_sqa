-- Por que contar nomes diferentes não conta pessoas.
-- Compara o nome limpo (sem acento, em minúsculas) com a pessoa que a regra da aula montou.
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
),
casadas AS (
    -- a linha da loja que achou o seu cliente no site
    SELECT id_loja, MIN(id_cliente) AS id_cliente, MIN(regra) AS regra,
           COUNT(DISTINCT id_cliente) AS clientes
    FROM pares
    WHERE regra <> 'telefone de outra pessoa'
    GROUP BY id_loja
),
duvidas AS (
    -- telefone igual ao de um cliente do site, com outro primeiro nome: não junta, vai para revisão
    SELECT id_loja, string_agg('telefone igual ao do cliente ' || id_cliente || ' do site', '; ') AS revisar
    FROM pares
    WHERE regra = 'telefone de outra pessoa'
    GROUP BY id_loja
),
soltas AS (
    -- as linhas da loja que não acharam cliente no site
    SELECT c.*
    FROM chaves c
    WHERE c.origem = 'loja'
      AND NOT EXISTS (SELECT 1 FROM casadas k WHERE k.id_loja = c.id_origem)
),
lider AS (
    -- cada linha solta vai para a primeira linha solta que é a mesma pessoa pela mesma regra
    SELECT a.id_origem, MIN(b.id_origem) AS grupo
    FROM soltas a
    JOIN soltas b ON a.email_chave = b.email_chave
                  OR (a.tel_chave = b.tel_chave AND a.primeiro_nome = b.primeiro_nome)
                  OR a.id_origem = b.id_origem
    GROUP BY a.id_origem
),
grupos AS (
    SELECT d.id_origem, d.grupo,
           CASE WHEN d.id_origem = d.grupo THEN NULL
                WHEN a.email_chave = b.email_chave THEN 'e-mail'
                ELSE 'telefone e nome' END AS regra
    FROM lider d
    JOIN soltas a ON a.id_origem = d.id_origem
    JOIN soltas b ON b.id_origem = d.grupo
),
donos AS (
    SELECT c.*,
           CASE WHEN c.origem = 'site' THEN 'site ' || c.id_origem
                WHEN k.id_loja IS NOT NULL THEN 'site ' || k.id_cliente
                ELSE 'loja ' || g.grupo END AS pessoa,
           COALESCE(c.id_cliente, k.id_cliente) AS cliente,
           COALESCE(k.regra, g.regra) AS regra,
           u.revisar
    FROM chaves c
    LEFT JOIN casadas k ON k.id_loja = c.id_origem
    LEFT JOIN grupos g ON g.id_origem = c.id_origem
    LEFT JOIN duvidas u ON u.id_loja = c.id_origem
),
consolidado AS (
    SELECT pessoa,
           MAX(cliente) AS id_cliente,
           first(nome ORDER BY prioridade, atualizado_em DESC, id_origem)
               FILTER (WHERE nome IS NOT NULL) AS nome,
           first(email_chave ORDER BY prioridade, atualizado_em DESC, id_origem)
               FILTER (WHERE email_chave IS NOT NULL) AS email,
           first(tel_chave ORDER BY atualizado_em DESC, prioridade, id_origem)
               FILTER (WHERE tel_chave IS NOT NULL) AS telefone,
           first(origem || ' ' || id_origem ORDER BY atualizado_em DESC, prioridade, id_origem)
               FILTER (WHERE tel_chave IS NOT NULL) AS telefone_de,
           first(cidade ORDER BY atualizado_em DESC, prioridade, id_origem)
               FILTER (WHERE cidade IS NOT NULL) AS cidade,
           first(origem || ' ' || id_origem ORDER BY atualizado_em DESC, prioridade, id_origem)
               FILTER (WHERE cidade IS NOT NULL) AS cidade_de,
           COUNT(*) AS linhas,
           string_agg(origem || ' ' || id_origem || COALESCE(' por ' || regra, ''), ', '
                      ORDER BY prioridade, id_origem) AS origens,
           string_agg(revisar, '; ') AS revisar
    FROM donos
    GROUP BY pessoa
),
nomes AS (
    SELECT pessoa, lower(strip_accents(trim(nome))) AS nome_limpo
    FROM donos
)
SELECT 'mesmo nome, duas pessoas' AS caso, nome_limpo AS nomes,
       string_agg(DISTINCT pessoa, ' e ' ORDER BY pessoa) AS pessoas
FROM nomes
GROUP BY nome_limpo
HAVING COUNT(DISTINCT pessoa) > 1
UNION ALL
SELECT 'uma pessoa, dois nomes', string_agg(DISTINCT nome_limpo, ' / ' ORDER BY nome_limpo), pessoa
FROM nomes
GROUP BY pessoa
HAVING COUNT(DISTINCT nome_limpo) > 1
ORDER BY caso, nomes;
