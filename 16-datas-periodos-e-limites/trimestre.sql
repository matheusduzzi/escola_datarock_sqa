-- Pedidos do primeiro trimestre num número só, com BETWEEN e com o intervalo meio aberto.
SELECT COUNT(*) FILTER (WHERE data_hora_pedido BETWEEN DATE '2026-01-01' AND DATE '2026-03-31') AS com_between,
       COUNT(*) FILTER (WHERE data_hora_pedido >= DATE '2026-01-01' AND data_hora_pedido < DATE '2026-04-01') AS meio_aberto
FROM pedidos;
