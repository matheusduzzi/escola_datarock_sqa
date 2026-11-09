-- A tabela de meses com as datas escritas como texto, sem DATE nem TIMESTAMP.
-- O DuckDB não compara texto com data e hora e para com erro.
WITH meses AS (
    SELECT * FROM (VALUES ('2026-03', '2026-03-01', '2026-04-01')) AS t(mes, inicio, fim)
)
SELECT m.mes, COUNT(p.id_pedido) AS pedidos
FROM meses AS m
LEFT JOIN pedidos AS p ON p.data_hora_pedido >= m.inicio AND p.data_hora_pedido < m.fim
GROUP BY m.mes;
