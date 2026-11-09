-- O mesmo selo buscado de dois jeitos, para o cliente 46 em duas datas: hoje (20/06) e 10/07/2026.
-- ASOF JOIN do DuckDB: pega a linha com o maior valido_de que não passa da data. Ele não olha o valido_ate.
CREATE VIEW selo_cliente AS SELECT * FROM read_csv('dados/selo_cliente.csv', header = true);

WITH datas AS (
    SELECT 46 AS id_cliente, DATE '2026-06-20' AS dia
    UNION ALL SELECT 46, DATE '2026-07-10'
)
SELECT 'começo entra, fim não entra' AS jeito, d.dia, s.selo, s.valido_de, s.valido_ate
FROM datas d
LEFT JOIN selo_cliente s
  ON s.id_cliente = d.id_cliente AND s.valido_de <= d.dia AND d.dia < s.valido_ate
UNION ALL
SELECT 'ASOF JOIN', d.dia, s.selo, s.valido_de, s.valido_ate
FROM datas d
ASOF LEFT JOIN selo_cliente s
  ON s.id_cliente = d.id_cliente AND d.dia >= s.valido_de
ORDER BY jeito DESC, dia;
