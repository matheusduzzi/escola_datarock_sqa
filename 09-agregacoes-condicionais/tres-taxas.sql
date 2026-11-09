-- A taxa de devolução por categoria, trocando uma regra por vez.
-- caio:             itens devolvidos / todos os itens da categoria
-- pedidos_todos:    pedidos devolvidos / todos os pedidos da categoria
-- pedidos_chegaram: pedidos devolvidos / pedidos que chegaram ao cliente (entregue ou devolvido)
SELECT d.categoria,
       ROUND(100.0 * COUNT(*) FILTER (WHERE p.status = 'devolvido')
             / COUNT(*), 1)                                                   AS caio,
       ROUND(100.0 * COUNT(DISTINCT p.id_pedido) FILTER (WHERE p.status = 'devolvido')
             / COUNT(DISTINCT p.id_pedido), 1)                                AS pedidos_todos,
       ROUND(100.0 * COUNT(DISTINCT p.id_pedido) FILTER (WHERE p.status = 'devolvido')
             / COUNT(DISTINCT p.id_pedido) FILTER (WHERE p.status IN ('entregue', 'devolvido')), 1)
                                                                              AS pedidos_chegaram
FROM itens_pedido i
JOIN pedidos  p ON p.id_pedido  = i.id_pedido
JOIN produtos d ON d.id_produto = i.id_produto
GROUP BY d.categoria
ORDER BY d.categoria;
