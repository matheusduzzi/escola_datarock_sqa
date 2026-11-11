-- O mesmo relatório nos arquivos por mês, com o filtro pela data do pedido, como na tabela.
SELECT canal, COUNT(DISTINCT id_pedido) AS pedidos, SUM(valor) AS vendido
FROM read_parquet('historico_por_mes/*/*/*.parquet', hive_partitioning = true)
WHERE data_hora_pedido >= TIMESTAMP '2026-05-01' AND data_hora_pedido < TIMESTAMP '2026-06-01'
GROUP BY canal
ORDER BY canal;
