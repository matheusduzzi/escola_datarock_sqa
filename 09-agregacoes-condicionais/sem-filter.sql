-- Os indicadores do indicadores.sql escritos com CASE dentro do SUM, sem FILTER.
-- É a forma que roda em bancos que não aceitam FILTER.
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
contagens AS (
    SELECT categoria,
           COUNT(*)                                                                AS pedidos,
           SUM(CASE WHEN status = 'cancelado' THEN 1 ELSE 0 END)                   AS cancelados,
           SUM(CASE WHEN status IN ('entregue', 'devolvido') THEN 1 ELSE 0 END)    AS chegaram,
           SUM(CASE WHEN status = 'devolvido' THEN 1 ELSE 0 END)                   AS devolvidos,
           SUM(CASE WHEN status = 'em_andamento' THEN 1 ELSE 0 END)                AS em_andamento,
           SUM(CASE WHEN status IN ('entregue', 'em_andamento') THEN valor END)    AS vendas
    FROM pedido_categoria
    GROUP BY categoria
)
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
