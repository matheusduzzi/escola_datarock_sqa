-- Unidades vendidas em cada dia, de 10 a 21 de janeiro. Pedido cancelado fica de fora.
-- As unidades de um pedido são a soma da quantidade dos itens. É a tabela do exercício.
SELECT CAST(p.data_hora_pedido AS DATE) AS dia,
       COUNT(DISTINCT p.id_pedido) AS pedidos,
       SUM(i.quantidade) AS unidades
FROM pedidos p
JOIN itens_pedido i USING (id_pedido)
WHERE p.status <> 'cancelado'
  AND p.data_hora_pedido >= DATE '2026-01-10'
  AND p.data_hora_pedido < DATE '2026-01-22'
GROUP BY 1
ORDER BY 1;
