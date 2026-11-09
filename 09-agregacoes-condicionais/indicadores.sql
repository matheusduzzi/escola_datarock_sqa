-- Indicadores por status e categoria, para o Renato.
-- 1. Uma linha por pedido dentro de cada categoria, com o valor que a categoria teve no pedido.
--    Um pedido com Casa e Eletro vira duas linhas: uma em Casa, outra em Eletro.
WITH pedido_categoria AS (
    SELECT d.categoria,
           p.id_pedido,
           p.status,
           SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor
    FROM itens_pedido i
    JOIN pedidos  p ON p.id_pedido  = i.id_pedido
    JOIN produtos d ON d.id_produto = i.id_produto
    GROUP BY d.categoria, p.id_pedido, p.status
),
-- 2. As contagens: cada coluna conta um grupo de status.
contagens AS (
    SELECT categoria,
           COUNT(*)                                                         AS pedidos,
           COUNT(*) FILTER (WHERE status = 'cancelado')                     AS cancelados,
           COUNT(*) FILTER (WHERE status IN ('entregue', 'devolvido'))      AS chegaram,
           COUNT(*) FILTER (WHERE status = 'devolvido')                     AS devolvidos,
           COUNT(*) FILTER (WHERE status = 'em_andamento')                  AS em_andamento,
           SUM(valor) FILTER (WHERE status IN ('entregue', 'em_andamento')) AS vendas
    FROM pedido_categoria
    GROUP BY categoria
)
-- 3. As taxas: cada uma divide pelo seu denominador.
SELECT categoria,
       pedidos,
       cancelados,
       ROUND(100.0 * cancelados / pedidos, 1)  AS pct_cancelado,
       chegaram,
       devolvidos,
       ROUND(100.0 * devolvidos / chegaram, 1) AS pct_devolvido,
       em_andamento,
       ROUND(vendas, 2)                        AS vendas
FROM contagens
ORDER BY categoria;
