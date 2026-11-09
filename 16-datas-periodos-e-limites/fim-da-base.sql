-- Até quando vão os pedidos da base.
SELECT MIN(data_hora_pedido) AS primeiro_pedido, MAX(data_hora_pedido) AS ultimo_pedido
FROM pedidos;
