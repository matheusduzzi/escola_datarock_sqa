-- Quando juntar direto não multiplica: cada item é de UM pedido e de UM produto.
-- A medida está nos itens, e todo JOIN aqui sai do item para o lado do "um".
SELECT COALESCE(pr.categoria, 'total') AS categoria,
       COUNT(*)                        AS itens,
       ROUND(SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)), 2) AS valor_itens
FROM itens_pedido i
JOIN pedidos p   ON p.id_pedido = i.id_pedido
JOIN produtos pr ON pr.id_produto = i.id_produto
WHERE p.status = 'entregue'
GROUP BY ROLLUP (pr.categoria)
ORDER BY pr.categoria NULLS LAST;
