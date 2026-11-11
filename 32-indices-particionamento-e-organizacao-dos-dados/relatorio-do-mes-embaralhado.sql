-- O mesmo relatório, na tabela gravada noutra ordem.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT canal, COUNT(DISTINCT id_pedido) AS pedidos, SUM(valor) AS vendido
FROM hist.itens_embaralhados
WHERE data_hora_pedido >= TIMESTAMP '2026-05-01' AND data_hora_pedido < TIMESTAMP '2026-06-01'
GROUP BY canal
ORDER BY canal;
