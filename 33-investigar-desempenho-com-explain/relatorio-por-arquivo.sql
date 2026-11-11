-- O mesmo relatório, lido dos arquivos Parquet separados por mês. O filtro usa as pastas: ano e mes.
SELECT canal, COUNT(DISTINCT id_pedido) AS pedidos, SUM(valor) AS vendido
FROM read_parquet('historico_por_mes/*/*/*.parquet', hive_partitioning = true)
WHERE ano = 2026 AND mes = 5
GROUP BY canal
ORDER BY canal;
