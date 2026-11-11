-- Apaga os índices em id_pedido das duas tabelas, para medir de novo sem eles.
ATTACH 'historico.duckdb' AS hist;
DROP INDEX IF EXISTS hist.ix_hist_pedido;
DROP INDEX IF EXISTS hist.ix_emb_pedido;
SELECT COUNT(*) AS indices FROM duckdb_indexes();
