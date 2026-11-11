-- O pedido da Lúcia: quanto cada categoria vendeu em maio para clientes de SP.
-- Pedidos entregues, valor do item com desconto.
SELECT pr.categoria,
       COUNT(DISTINCT p.id_pedido) AS pedidos,
       ROUND(SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)), 2) AS vendido
FROM pedidos p
JOIN clientes c ON c.id_cliente = p.id_cliente
JOIN itens_pedido i ON i.id_pedido = p.id_pedido
JOIN produtos pr ON pr.id_produto = i.id_produto
WHERE p.status = 'entregue'
  AND c.uf = 'SP'
  AND p.data_hora_pedido >= TIMESTAMP '2026-05-01'
  AND p.data_hora_pedido <  TIMESTAMP '2026-06-01'
GROUP BY pr.categoria
ORDER BY vendido DESC;
