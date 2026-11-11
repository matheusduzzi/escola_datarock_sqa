-- Cenário 2. O painel da operação mostra o vendido do dia anterior, por canal.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT canal, COUNT(DISTINCT id_pedido) AS pedidos, SUM(valor) AS vendido
FROM hist.itens_historico
WHERE data_hora_pedido >= TIMESTAMP '2026-06-23' AND data_hora_pedido < TIMESTAMP '2026-06-24'
GROUP BY canal
ORDER BY canal;
