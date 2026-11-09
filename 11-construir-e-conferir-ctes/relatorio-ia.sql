-- O relatório que a IA escreveu para o Renato: venda e pedidos de cada categoria por mês.
-- Roda sem erro. A aula mostra onde ele quebra.
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
),
por_mes_categoria AS (
    SELECT mes,
           categoria,
           SUM(valor) AS venda,
           COUNT(*)   AS pedidos
    FROM itens_categoria
    GROUP BY mes, categoria
)
SELECT mes, categoria, ROUND(venda, 2) AS venda, pedidos
FROM por_mes_categoria
ORDER BY mes, categoria;
