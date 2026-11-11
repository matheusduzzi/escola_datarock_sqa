-- A versão que a IA mandou para o relatório de Presentes.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT strftime(data_hora_pedido, '%Y-%m') AS mes,
       COUNT(*) AS pedidos,
       SUM(valor) AS valor_dos_pedidos
FROM hist.itens_historico
WHERE categoria = 'Presentes'
  AND data_hora_pedido >= TIMESTAMP '2026-01-01'
GROUP BY mes
ORDER BY mes;
