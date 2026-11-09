-- As regras do histórico de endereço, e quantos clientes quebram cada uma.
-- Para checar outro arquivo, troque o caminho do read_csv da linha abaixo.
CREATE VIEW historico_endereco AS SELECT * FROM read_csv('dados/historico_endereco.csv', header = true);

WITH h AS (SELECT * FROM historico_endereco),
quebras AS (
    -- 1. O mesmo cliente não tem dois períodos começando no mesmo dia.
    SELECT 1 AS n, 'o começo não repete' AS regra, id_cliente
    FROM h GROUP BY id_cliente, valido_de HAVING COUNT(*) > 1
    UNION ALL
    -- 2. O fim vem depois do começo.
    SELECT 2, 'o fim vem depois do começo', id_cliente
    FROM h WHERE valido_ate IS NOT NULL AND valido_ate <= valido_de
    UNION ALL
    -- 3. O primeiro período começa no dia do cadastro (e todo cliente tem histórico).
    SELECT 3, 'começa no dia do cadastro', c.id_cliente
    FROM clientes c LEFT JOIN h USING (id_cliente)
    GROUP BY c.id_cliente, c.data_cadastro
    HAVING MIN(h.valido_de) IS DISTINCT FROM c.data_cadastro
    UNION ALL
    -- 4. Dois períodos do mesmo cliente não se cruzam. Fim vazio quer dizer sem fim.
    SELECT 4, 'sem sobreposição', a.id_cliente
    FROM h a JOIN h b
      ON a.id_cliente = b.id_cliente
     AND a.valido_de < b.valido_de
     AND (a.valido_ate IS NULL OR a.valido_ate > b.valido_de)
    UNION ALL
    -- 5. Quando um período termina, o próximo começa no mesmo dia.
    SELECT 5, 'sem buraco', a.id_cliente
    FROM h a
    WHERE a.valido_ate IS NOT NULL
      AND NOT EXISTS (SELECT 1 FROM h b WHERE b.id_cliente = a.id_cliente AND b.valido_de = a.valido_ate)
    UNION ALL
    -- 6. Cada cliente tem um período sem fim, e só um.
    SELECT 6, 'um período sem fim', id_cliente
    FROM h GROUP BY id_cliente HAVING COUNT(*) FILTER (WHERE valido_ate IS NULL) <> 1
),
regras AS (
    SELECT * FROM (VALUES (1, 'o começo não repete'), (2, 'o fim vem depois do começo'),
                          (3, 'começa no dia do cadastro'), (4, 'sem sobreposição'),
                          (5, 'sem buraco'), (6, 'um período sem fim')) AS r(n, regra)
)
SELECT r.n, r.regra,
       COUNT(DISTINCT q.id_cliente) AS clientes_que_quebram,
       COALESCE(array_to_string(list_sort(list(DISTINCT q.id_cliente)), ', '), '') AS quais
FROM regras r
LEFT JOIN quebras q USING (n)
GROUP BY r.n, r.regra
ORDER BY r.n;
