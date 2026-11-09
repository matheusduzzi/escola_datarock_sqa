-- O que chegou primeiro para a Bruna: as duas listas empilhadas, sem repetir linha,
-- e a conta de nomes diferentes, primeiro em minúsculas e depois também sem acento.
SELECT
    (SELECT COUNT(*) FROM (SELECT nome, email, telefone FROM site
                           UNION ALL
                           SELECT nome, email, telefone FROM loja)) AS empilhadas,
    (SELECT COUNT(*) FROM (SELECT nome, email, telefone FROM site
                           UNION
                           SELECT nome, email, telefone FROM loja)) AS com_union,
    (SELECT COUNT(DISTINCT lower(trim(nome)))
     FROM (SELECT nome FROM site UNION ALL SELECT nome FROM loja)) AS nomes_minusculos,
    (SELECT COUNT(DISTINCT lower(strip_accents(trim(nome))))
     FROM (SELECT nome FROM site UNION ALL SELECT nome FROM loja)) AS nomes_sem_acento;
