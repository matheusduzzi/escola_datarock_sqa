-- Os pedidos sem nenhuma linha em entregas, por status.
SELECT p.status, COUNT(*) AS pedidos
FROM pedidos p
WHERE NOT EXISTS (SELECT 1 FROM entregas e WHERE e.id_pedido = p.id_pedido)
GROUP BY p.status
ORDER BY p.status;
