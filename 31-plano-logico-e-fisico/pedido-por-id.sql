-- A tela do atendimento: um pedido pelo id.
ATTACH 'loja.duckdb' AS loja (READ_ONLY);
SELECT * FROM loja.regra_pedido WHERE id_pedido = 680;
