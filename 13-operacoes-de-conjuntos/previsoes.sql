-- Exercício, tarefa 1. As sete consultas sobre as inscrições do sorteio.
-- Preencha a folha-previsao.md ANTES de rodar este arquivo.
-- Cada linha da saída é uma consulta: quantas linhas ela retorna e quais id_cliente aparecem, em ordem.
WITH app AS (SELECT id_cliente FROM inscricoes_app),
     loja AS (SELECT id_cliente FROM inscricoes_loja),
     c1 AS (SELECT id_cliente FROM app UNION ALL     SELECT id_cliente FROM loja),
     c2 AS (SELECT id_cliente FROM app UNION         SELECT id_cliente FROM loja),
     c3 AS (SELECT id_cliente FROM app INTERSECT     SELECT id_cliente FROM loja),
     c4 AS (SELECT id_cliente FROM app INTERSECT ALL SELECT id_cliente FROM loja),
     c5 AS (SELECT id_cliente FROM app EXCEPT        SELECT id_cliente FROM loja),
     c6 AS (SELECT id_cliente FROM app EXCEPT ALL    SELECT id_cliente FROM loja),
     c7 AS (SELECT id_cliente FROM loja EXCEPT ALL   SELECT id_cliente FROM app)
SELECT consulta, linhas, ids
FROM (VALUES
    ('C1 app UNION ALL loja',     (SELECT COUNT(*) FROM c1), (SELECT string_agg(id_cliente::VARCHAR, ' ' ORDER BY id_cliente) FROM c1)),
    ('C2 app UNION loja',         (SELECT COUNT(*) FROM c2), (SELECT string_agg(id_cliente::VARCHAR, ' ' ORDER BY id_cliente) FROM c2)),
    ('C3 app INTERSECT loja',     (SELECT COUNT(*) FROM c3), (SELECT string_agg(id_cliente::VARCHAR, ' ' ORDER BY id_cliente) FROM c3)),
    ('C4 app INTERSECT ALL loja', (SELECT COUNT(*) FROM c4), (SELECT string_agg(id_cliente::VARCHAR, ' ' ORDER BY id_cliente) FROM c4)),
    ('C5 app EXCEPT loja',        (SELECT COUNT(*) FROM c5), (SELECT string_agg(id_cliente::VARCHAR, ' ' ORDER BY id_cliente) FROM c5)),
    ('C6 app EXCEPT ALL loja',    (SELECT COUNT(*) FROM c6), (SELECT string_agg(id_cliente::VARCHAR, ' ' ORDER BY id_cliente) FROM c6)),
    ('C7 loja EXCEPT ALL app',    (SELECT COUNT(*) FROM c7), (SELECT string_agg(id_cliente::VARCHAR, ' ' ORDER BY id_cliente) FROM c7))
) AS resumo(consulta, linhas, ids)
ORDER BY consulta;
