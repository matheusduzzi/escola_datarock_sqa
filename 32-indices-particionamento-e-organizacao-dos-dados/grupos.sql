-- O mapa de mínimo e máximo de cada grupo de linhas, nas duas tabelas.
-- O DuckDB grava a tabela em grupos de 122.880 linhas e guarda o menor e o maior valor de cada coluna em cada grupo.
-- Aqui o rowid (a posição da linha na tabela) dividido por 122.880 dá o número do grupo.
-- Para cada pedido da aula, a consulta conta em quantos grupos a resposta pode estar:
-- os grupos em que o valor procurado cabe entre o mínimo e o máximo. Os outros, o banco pula.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
WITH grupos AS (
    SELECT 'itens_historico' AS tabela, rowid // 122880 AS grupo,
           MIN(id_pedido) AS min_pedido, MAX(id_pedido) AS max_pedido,
           MIN(data_hora_pedido) AS min_data, MAX(data_hora_pedido) AS max_data,
           MIN(categoria) AS min_cat, MAX(categoria) AS max_cat
    FROM hist.itens_historico GROUP BY 1, 2
    UNION ALL
    SELECT 'itens_embaralhados', rowid // 122880,
           MIN(id_pedido), MAX(id_pedido), MIN(data_hora_pedido), MAX(data_hora_pedido), MIN(categoria), MAX(categoria)
    FROM hist.itens_embaralhados GROUP BY 1, 2
)
SELECT tabela,
       COUNT(*) AS grupos,
       COUNT(*) FILTER (WHERE 1400000 BETWEEN min_pedido AND max_pedido) AS pedido_1400000,
       COUNT(*) FILTER (WHERE max_data >= TIMESTAMP '2026-05-01' AND min_data < TIMESTAMP '2026-06-01') AS maio_2026,
       COUNT(*) FILTER (WHERE 'Eletro' BETWEEN min_cat AND max_cat) AS eletro
FROM grupos
GROUP BY tabela
ORDER BY tabela DESC;
