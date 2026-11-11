-- O pedido da diretoria: os pedidos acima de R$ 1.000.
ATTACH 'loja.duckdb' AS loja (READ_ONLY);
SELECT * FROM loja.regra_pedido WHERE valor > 1000 ORDER BY id_pedido;
