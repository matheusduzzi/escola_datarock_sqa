-- Os mesmos indicadores para a loja inteira, com uma linha por pedido.
-- A última linha soma as linhas das categorias, para comparar.
WITH pedido AS (
    SELECT p.id_pedido,
           p.status,
           SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor
    FROM pedidos p
    JOIN itens_pedido i ON i.id_pedido = p.id_pedido
    GROUP BY p.id_pedido, p.status
),
pedido_categoria AS (
    SELECT d.categoria,
           p.id_pedido,
           p.status,
           SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor
    FROM itens_pedido i
    JOIN pedidos  p ON p.id_pedido  = i.id_pedido
    JOIN produtos d ON d.id_produto = i.id_produto
    GROUP BY d.categoria, p.id_pedido, p.status
)
SELECT 'loja inteira'                                                AS linha,
       COUNT(*)                                                      AS pedidos,
       COUNT(*) FILTER (WHERE status = 'cancelado')                  AS cancelados,
       COUNT(*) FILTER (WHERE status IN ('entregue', 'devolvido'))   AS chegaram,
       COUNT(*) FILTER (WHERE status = 'devolvido')                  AS devolvidos,
       ROUND(SUM(valor) FILTER (WHERE status IN ('entregue', 'em_andamento')), 2) AS vendas
FROM pedido
UNION ALL
SELECT 'soma das categorias',
       COUNT(*),
       COUNT(*) FILTER (WHERE status = 'cancelado'),
       COUNT(*) FILTER (WHERE status IN ('entregue', 'devolvido')),
       COUNT(*) FILTER (WHERE status = 'devolvido'),
       ROUND(SUM(valor) FILTER (WHERE status IN ('entregue', 'em_andamento')), 2)
FROM pedido_categoria;
