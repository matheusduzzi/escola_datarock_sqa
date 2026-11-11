-- A tela do atendimento: os itens de um pedido, pelo id.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT * FROM hist.itens_historico WHERE id_pedido = 1400000 ORDER BY id_item;
