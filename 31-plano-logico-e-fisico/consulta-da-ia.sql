-- A versão que a IA mandou, com o comentário dela:
-- "Versão otimizada: filtra pedidos e clientes antes de juntar,
--  assim o banco junta menos linhas e a consulta fica mais rápida."
WITH pedidos_maio AS (
    SELECT id_pedido, id_cliente
    FROM pedidos
    WHERE status = 'entregue'
      AND data_hora_pedido >= TIMESTAMP '2026-05-01'
      AND data_hora_pedido <  TIMESTAMP '2026-06-01'
),
clientes_sp AS (
    SELECT id_cliente FROM clientes WHERE uf = 'SP'
),
pedidos_sp AS (
    SELECT p.id_pedido
    FROM pedidos_maio p
    JOIN clientes_sp c ON c.id_cliente = p.id_cliente
)
SELECT pr.categoria,
       COUNT(DISTINCT s.id_pedido) AS pedidos,
       ROUND(SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)), 2) AS vendido
FROM pedidos_sp s
JOIN itens_pedido i ON i.id_pedido = s.id_pedido
JOIN produtos pr ON pr.id_produto = i.id_produto
GROUP BY pr.categoria
ORDER BY vendido DESC;
