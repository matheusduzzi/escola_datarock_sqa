-- O relatório de Presentes como o Caio escreveu: por mês de 2026, os pedidos que tiveram pelo menos um item
-- da categoria Presentes e o valor desses pedidos inteiros, com todos os itens.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT strftime(data_hora_pedido, '%Y-%m') AS mes,
       COUNT(DISTINCT id_pedido) AS pedidos,
       SUM(valor) AS valor_dos_pedidos
FROM hist.itens_historico
WHERE year(data_hora_pedido) = 2026
  AND id_pedido IN (SELECT id_pedido FROM hist.itens_historico WHERE categoria = 'Presentes')
GROUP BY mes
ORDER BY mes;
