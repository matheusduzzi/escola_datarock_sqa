-- Cenário 1. O atendimento quer abrir a ficha de um cliente: todos os itens que ele comprou.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT id_pedido, data_hora_pedido, categoria, valor
FROM hist.itens_historico
WHERE id_cliente = 27309
ORDER BY data_hora_pedido, id_item;
