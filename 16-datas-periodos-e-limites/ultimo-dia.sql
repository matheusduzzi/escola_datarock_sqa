-- Os pedidos de 31 de março: quantos foram feitos exatamente à meia-noite e quantos no dia todo.
SELECT COUNT(*) FILTER (WHERE data_hora_pedido = TIMESTAMP '2026-03-31 00:00:00') AS a_meia_noite,
       COUNT(*) AS no_dia_todo
FROM pedidos
WHERE data_hora_pedido >= TIMESTAMP '2026-03-31' AND data_hora_pedido < TIMESTAMP '2026-04-01';
