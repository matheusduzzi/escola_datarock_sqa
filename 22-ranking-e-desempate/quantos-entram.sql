-- Pedido 2 da prática: quantos produtos de cada categoria passam no corte "até 3"
-- com cada função. O ROW_NUMBER usa a regra da Lúcia; RANK e DENSE_RANK, só as unidades.
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
    SELECT categoria,
           ROW_NUMBER() OVER (PARTITION BY categoria
                              ORDER BY unidades DESC, pedidos DESC, id_produto) AS row_number,
           RANK()       OVER (PARTITION BY categoria ORDER BY unidades DESC) AS rank,
           DENSE_RANK() OVER (PARTITION BY categoria ORDER BY unidades DESC) AS dense_rank
    FROM vendas
)
SELECT categoria,
       COUNT(*) FILTER (WHERE row_number <= 3) AS com_row_number,
       COUNT(*) FILTER (WHERE rank <= 3) AS com_rank,
       COUNT(*) FILTER (WHERE dense_rank <= 3) AS com_dense_rank
FROM ranking
GROUP BY categoria
ORDER BY categoria;
