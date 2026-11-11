-- Os pedidos do recorte sem pagamento aprovado e o que acontece com o a receber de cada um.
WITH pagos AS (
  SELECT id_pedido, SUM(valor) AS recebido
  FROM pagamentos WHERE status = 'aprovado' GROUP BY id_pedido
),
itens AS (
  SELECT id_pedido, ROUND(SUM(quantidade * preco_unitario - COALESCE(desconto, 0)), 2) AS valor_itens
  FROM itens_pedido GROUP BY id_pedido
)
SELECT p.id_pedido, p.status, i.valor_itens, g.recebido,
       i.valor_itens - g.recebido AS sem_coalesce,
       i.valor_itens - COALESCE(g.recebido, 0) AS com_coalesce
FROM pedidos p
JOIN itens i ON i.id_pedido = p.id_pedido
LEFT JOIN pagos g ON g.id_pedido = p.id_pedido
WHERE p.status <> 'cancelado'
  AND p.data_hora_pedido >= TIMESTAMP '2026-06-01 00:00:00'
  AND p.data_hora_pedido <  TIMESTAMP '2026-06-21 00:00:00'
  AND g.recebido IS NULL
ORDER BY p.id_pedido
