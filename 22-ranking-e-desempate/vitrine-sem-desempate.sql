-- A primeira versão da vitrine: os 3 mais vendidos de cada categoria, só por unidades.
-- Rode mais de uma vez com o repetir.py e veja o que muda.
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
    SELECT categoria, produto, unidades, pedidos,
           ROW_NUMBER() OVER (PARTITION BY categoria ORDER BY unidades DESC) AS posicao
    FROM vendas
)
SELECT categoria, posicao, produto, unidades, pedidos
FROM ranking
WHERE posicao <= 3
ORDER BY categoria, posicao;
