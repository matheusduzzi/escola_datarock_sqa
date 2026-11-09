-- Da base inteira até a etapa vendas: o que saiu, e por quê.
-- Uma linha por status do pedido, com pedidos, itens e valor dos itens.
SELECT p.status,
       CASE WHEN p.status IN ('entregue', 'em_andamento') THEN 'entra' ELSE 'sai' END AS em_vendas,
       COUNT(DISTINCT p.id_pedido) AS pedidos,
       COUNT(*)                    AS itens,
       ROUND(SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)), 2) AS valor
FROM pedidos p
JOIN itens_pedido i ON i.id_pedido = p.id_pedido
GROUP BY p.status
ORDER BY em_vendas, p.status;
