-- Fechamento parcial de junho, até o dia 20, como o Diego mandou.
-- Pedidos que não foram cancelados: entregues e em andamento.
WITH por_pedido AS (
  SELECT p.id_pedido,
         SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor_itens,
         SUM(e.custo_frete) AS frete,
         SUM(g.valor) AS recebido
  FROM pedidos p
  JOIN itens_pedido i ON i.id_pedido = p.id_pedido
  LEFT JOIN entregas e ON e.id_pedido = p.id_pedido
  LEFT JOIN pagamentos g ON g.id_pedido = p.id_pedido AND g.status = 'aprovado'
  WHERE p.status <> 'cancelado'
    AND p.data_hora_pedido BETWEEN '2026-06-01' AND '2026-06-20'
  GROUP BY p.id_pedido
)
SELECT COUNT(*) AS pedidos,
       ROUND(SUM(valor_itens), 2) AS faturamento,
       ROUND(SUM(frete), 2) AS frete,
       ROUND(SUM(recebido), 2) AS recebido,
       ROUND(SUM(valor_itens - recebido), 2) AS a_receber
FROM por_pedido
