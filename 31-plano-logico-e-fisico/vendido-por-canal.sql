-- Vendido por canal, pedidos entregues. O filtro está no WHERE, depois do JOIN.
SELECT p.canal,
       COUNT(DISTINCT p.id_pedido) AS pedidos,
       ROUND(SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)), 2) AS vendido
FROM pedidos p
JOIN itens_pedido i ON i.id_pedido = p.id_pedido
WHERE p.status = 'entregue'
GROUP BY p.canal
ORDER BY p.canal;
