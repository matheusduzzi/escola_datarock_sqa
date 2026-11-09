-- As vendas de março por produto: a tabela de partida do exercício.
-- Mesmas regras de fevereiro (só pedido entregue), com o preço de lista e o faturamento.
-- Faturamento = quantidade * preco_unitario - desconto, somado nos itens entregues.
WITH vendas AS (
    SELECT d.categoria, d.id_produto, d.nome AS produto, d.preco_lista,
           SUM(i.quantidade) AS unidades,
           COUNT(DISTINCT p.id_pedido) AS pedidos,
           ROUND(SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)), 2) AS faturamento
    FROM pedidos p
    JOIN itens_pedido i USING (id_pedido)
    JOIN produtos d USING (id_produto)
    WHERE p.status = 'entregue'
      AND p.data_hora_pedido >= '2026-03-01' AND p.data_hora_pedido < '2026-04-01'
    GROUP BY 1, 2, 3, 4
)
SELECT * FROM vendas
ORDER BY categoria, id_produto;
