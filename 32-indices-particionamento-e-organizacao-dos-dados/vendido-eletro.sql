-- O pedido de compras: quanto a categoria Eletro vendeu no histórico todo.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT COUNT(*) AS itens, COUNT(DISTINCT id_pedido) AS pedidos, SUM(valor) AS vendido
FROM hist.itens_historico
WHERE categoria = 'Eletro';
