-- Cria um índice ART na coluna id_pedido das duas tabelas. Para desfazer: DROP INDEX hist.ix_hist_pedido;
ATTACH 'historico.duckdb' AS hist;
CREATE INDEX IF NOT EXISTS ix_hist_pedido ON hist.itens_historico (id_pedido);
CREATE INDEX IF NOT EXISTS ix_emb_pedido ON hist.itens_embaralhados (id_pedido);
SELECT index_name, table_name, sql FROM duckdb_indexes() ORDER BY index_name;
