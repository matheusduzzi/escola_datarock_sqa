-- Consulta 1 do exercício: roda no DuckDB do kit. A tarefa é levar para o BigQuery.
SELECT date_trunc('month', data_hora_pedido) AS mes,
       COUNT(*) AS pedidos,
       SUM(CASE WHEN canal = 'app' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS pct_app
FROM pedidos
GROUP BY mes
ORDER BY mes;
