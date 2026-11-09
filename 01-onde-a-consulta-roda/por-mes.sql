-- Pedidos por mês com date_trunc, do jeito que o DuckDB escreve.
-- Rode dentro da pasta da aula:  python3 consultar.py --dados ../dados --arquivo por-mes.sql
SELECT date_trunc('month', data_hora_pedido) AS mes,
       COUNT(*) AS pedidos
FROM pedidos
GROUP BY mes
ORDER BY mes;
