-- Os três primeiros grupos de linhas de cada tabela, com a menor e a maior data de cada um.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT tabela, grupo, COUNT(*) AS linhas, MIN(data_hora_pedido) AS menor_data, MAX(data_hora_pedido) AS maior_data
FROM (SELECT 'itens_historico' AS tabela, rowid // 122880 AS grupo, data_hora_pedido FROM hist.itens_historico
      UNION ALL
      SELECT 'itens_embaralhados', rowid // 122880, data_hora_pedido FROM hist.itens_embaralhados)
WHERE grupo < 3
GROUP BY tabela, grupo
ORDER BY tabela DESC, grupo;
