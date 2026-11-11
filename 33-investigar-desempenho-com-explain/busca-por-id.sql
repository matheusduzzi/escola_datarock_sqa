-- A tela do atendimento: os itens de um pedido, pelo id. O pedido 400000 existe em qualquer volume do montar.py.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT * FROM hist.itens_historico WHERE id_pedido = 400000 ORDER BY id_item;
