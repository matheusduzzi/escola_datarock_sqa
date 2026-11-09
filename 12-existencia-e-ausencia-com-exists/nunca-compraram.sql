-- Clientes que nunca fizeram pedido: com NOT EXISTS e com LEFT JOIN e IS NULL.
SELECT (SELECT COUNT(*) FROM clientes c
         WHERE NOT EXISTS (SELECT 1 FROM pedidos p WHERE p.id_cliente = c.id_cliente)) AS com_not_exists,
       (SELECT COUNT(*) FROM clientes c
         LEFT JOIN pedidos p ON p.id_cliente = c.id_cliente
         WHERE p.id_pedido IS NULL)                                                 AS com_left_join,
       (SELECT MIN(data_cadastro) FROM clientes c
         WHERE NOT EXISTS (SELECT 1 FROM pedidos p WHERE p.id_cliente = c.id_cliente)) AS cadastro_mais_antigo;
