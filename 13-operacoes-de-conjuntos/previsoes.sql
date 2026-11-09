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
SELECT 'C1 app UNION ALL loja'      AS consulta, COUNT(*) AS linhas, string_agg(id_cliente::VARCHAR, ' ' ORDER BY id_cliente) AS ids FROM c1
UNION ALL SELECT 'C2 app UNION loja',          COUNT(*), string_agg(id_cliente::VARCHAR, ' ' ORDER BY id_cliente) FROM c2
UNION ALL SELECT 'C3 app INTERSECT loja',      COUNT(*), string_agg(id_cliente::VARCHAR, ' ' ORDER BY id_cliente) FROM c3
UNION ALL SELECT 'C4 app INTERSECT ALL loja',  COUNT(*), string_agg(id_cliente::VARCHAR, ' ' ORDER BY id_cliente) FROM c4
UNION ALL SELECT 'C5 app EXCEPT loja',         COUNT(*), string_agg(id_cliente::VARCHAR, ' ' ORDER BY id_cliente) FROM c5
UNION ALL SELECT 'C6 app EXCEPT ALL loja',     COUNT(*), string_agg(id_cliente::VARCHAR, ' ' ORDER BY id_cliente) FROM c6
UNION ALL SELECT 'C7 loja EXCEPT ALL app',     COUNT(*), string_agg(id_cliente::VARCHAR, ' ' ORDER BY id_cliente) FROM c7
ORDER BY consulta;
