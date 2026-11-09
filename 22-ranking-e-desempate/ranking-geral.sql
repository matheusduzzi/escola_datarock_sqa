-- Pedido 1 da prática: o ranking de fevereiro sem separar por categoria.
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
    SELECT produto, categoria, id_produto, unidades,
           RANK()       OVER (ORDER BY unidades DESC) AS rank,
           DENSE_RANK() OVER (ORDER BY unidades DESC) AS dense_rank
    FROM vendas
)
SELECT produto, categoria, unidades, rank, dense_rank
FROM ranking
WHERE rank <= 10
ORDER BY unidades DESC, id_produto;
