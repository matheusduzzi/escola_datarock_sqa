-- Cenário 4. O time de compras quer acompanhar a categoria Presentes, que ainda vende pouco.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT COUNT(*) AS itens, COUNT(DISTINCT id_pedido) AS pedidos, SUM(valor) AS vendido
FROM hist.itens_historico
WHERE categoria = 'Presentes';
