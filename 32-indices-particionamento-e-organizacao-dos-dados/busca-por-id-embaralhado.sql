-- A mesma busca, na tabela gravada noutra ordem.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT * FROM hist.itens_embaralhados WHERE id_pedido = 1400000 ORDER BY id_item;
