-- O cadastro (clientes) guarda a cidade de hoje. O histórico guarda cada cidade com o período em que valeu.
-- Hoje, no caso, é 20/06/2026, o último dia da base.
CREATE VIEW historico_endereco AS SELECT * FROM read_csv('dados/historico_endereco.csv', header = true);

WITH de_hoje AS (
    SELECT *
    FROM historico_endereco
    WHERE valido_de <= DATE '2026-06-20'
      AND (valido_ate IS NULL OR DATE '2026-06-20' < valido_ate)
)
SELECT (SELECT COUNT(*) FROM clientes)                    AS clientes,
       (SELECT COUNT(*) FROM historico_endereco)          AS linhas_historico,
       (SELECT COUNT(DISTINCT id_cliente) FROM historico_endereco
         WHERE valido_ate IS NOT NULL)                    AS clientes_que_mudaram,
       COUNT(*)                                           AS linhas_de_hoje,
       COUNT(*) FILTER (WHERE h.cidade = c.cidade AND h.uf = c.uf) AS iguais_ao_cadastro
FROM de_hoje h
JOIN clientes c USING (id_cliente);
