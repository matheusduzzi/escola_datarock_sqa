-- Consulta 2 do exercício: roda no DuckDB do kit. A tarefa é levar para o MySQL 8.4.
SELECT p.id_pedido,
       "status",
       c.cidade || '/' || c.uf AS destino
FROM pedidos p
JOIN clientes c ON c.id_cliente = p.id_cliente
WHERE p.id_pedido = 3;
