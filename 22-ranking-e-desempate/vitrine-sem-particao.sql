-- Pedido 3 da prática: a regra da Lúcia sem o PARTITION BY.
WITH vendas AS (
    SELECT d.categoria, d.id_produto, d.nome AS produto,
           SUM(i.quantidade) AS unidades,
           COUNT(DISTINCT p.id_pedido) AS pedidos
    FROM pedidos p
    JOIN itens_pedido i USING (id_pedido)
    JOIN produtos d USING (id_produto)
    WHERE p.status = 'entregue'
      AND p.data_hora_pedido >= '2026-02-01' AND p.data_hora_pedido < '2026-03-01'
    GROUP BY 1, 2, 3
),
ranking AS (
    SELECT categoria, id_produto, produto, unidades, pedidos,
           ROW_NUMBER() OVER (ORDER BY unidades DESC, pedidos DESC, id_produto) AS posicao
    FROM vendas
)
SELECT posicao, categoria, id_produto, produto, unidades, pedidos
FROM ranking
WHERE posicao <= 3
ORDER BY posicao;
