-- Cenário 3. O fechamento anual: o vendido de 2025 por canal, uma vez por ano.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT canal, COUNT(DISTINCT id_pedido) AS pedidos, SUM(valor) AS vendido
FROM hist.itens_historico
WHERE data_hora_pedido >= TIMESTAMP '2025-01-01' AND data_hora_pedido < TIMESTAMP '2026-01-01'
GROUP BY canal
ORDER BY canal;
