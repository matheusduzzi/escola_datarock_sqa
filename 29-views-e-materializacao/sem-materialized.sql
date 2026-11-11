-- O comando de view materializada do PostgreSQL, rodado no DuckDB do kit.
-- O DuckDB não tem esse comando: a consulta não roda, de propósito.
CREATE MATERIALIZED VIEW vendas_maio AS
SELECT COUNT(*) AS pedidos FROM pedidos;
