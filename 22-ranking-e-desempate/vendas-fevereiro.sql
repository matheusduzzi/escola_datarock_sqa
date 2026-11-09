-- As vendas de fevereiro por produto: a tabela de partida da aula.
-- Conta só pedido entregue. "pedidos" é em quantos pedidos diferentes o produto saiu.
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
)
SELECT * FROM vendas
ORDER BY categoria, unidades DESC, pedidos DESC, id_produto;
