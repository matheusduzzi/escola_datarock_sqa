-- O pedido 6 dentro da etapa itens_categoria do relatório da IA.
WITH vendas AS (
    SELECT p.id_pedido,
           strftime(p.data_hora_pedido, '%Y-%m') AS mes,
           SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor_pedido
    FROM pedidos p
    JOIN itens_pedido i ON i.id_pedido = p.id_pedido
    WHERE p.status IN ('entregue', 'em_andamento')
    GROUP BY p.id_pedido, mes
),
itens_categoria AS (
    SELECT v.id_pedido,
           i.n_item,
           v.mes,
           pr.categoria,
           v.valor_pedido AS valor
    FROM vendas v
    JOIN itens_pedido i ON i.id_pedido = v.id_pedido
    JOIN produtos pr    ON pr.id_produto = i.id_produto
)
SELECT ic.id_pedido,
       ic.n_item,
       ic.categoria,
       ROUND(ic.valor, 2) AS valor,
       ROUND(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0), 2) AS valor_do_item
FROM itens_categoria ic
JOIN itens_pedido i ON i.id_pedido = ic.id_pedido AND i.n_item = ic.n_item
WHERE ic.id_pedido = 6
ORDER BY ic.n_item;
