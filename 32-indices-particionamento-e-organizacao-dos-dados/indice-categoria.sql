-- Cria um índice ART na coluna categoria. Para desfazer: DROP INDEX hist.ix_hist_categoria;
ATTACH 'historico.duckdb' AS hist;
CREATE INDEX IF NOT EXISTS ix_hist_categoria ON hist.itens_historico (categoria);
SELECT index_name, table_name, sql FROM duckdb_indexes() ORDER BY index_name;
