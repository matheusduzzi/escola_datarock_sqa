-- O relatório de frete que a IA escreveu para o Rafael: frete e pedidos de cada transportadora por mês,
-- só nos pedidos que contam como venda. Roda sem erro. É o arquivo do exercício.
WITH vendas AS (
    SELECT id_pedido,
           strftime(data_hora_pedido, '%Y-%m') AS mes
    FROM pedidos
    WHERE status IN ('entregue', 'em_andamento')
),
frete_pedido AS (
    SELECT v.id_pedido,
           v.mes,
           SUM(e.custo_frete) AS frete
    FROM vendas v
    JOIN entregas e ON e.id_pedido = v.id_pedido
    GROUP BY v.id_pedido, v.mes
),
entregas_venda AS (
    SELECT f.id_pedido,
           e.id_entrega,
           f.mes,
           e.transportadora,
           f.frete
    FROM frete_pedido f
    JOIN entregas e ON e.id_pedido = f.id_pedido
),
por_mes_transportadora AS (
    SELECT mes,
           transportadora,
           SUM(frete) AS frete,
           COUNT(*)   AS pedidos
    FROM entregas_venda
    GROUP BY mes, transportadora
)
SELECT mes, transportadora, ROUND(frete, 2) AS frete, pedidos
FROM por_mes_transportadora
ORDER BY mes, transportadora;
