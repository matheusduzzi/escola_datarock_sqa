-- Comparar dinheiro sem arredondar: quantos pedidos do recorte "têm diferença" em cada jeito de comparar.
WITH recorte AS (
  SELECT id_pedido FROM pedidos
  WHERE status <> 'cancelado'
    AND data_hora_pedido >= TIMESTAMP '2026-06-01 00:00:00'
    AND data_hora_pedido <  TIMESTAMP '2026-06-21 00:00:00'
),
itens AS (
  SELECT id_pedido, SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS valor_itens
  FROM itens_pedido GROUP BY id_pedido
),
pagos AS (
  SELECT id_pedido, SUM(valor) AS recebido
  FROM pagamentos WHERE status = 'aprovado' GROUP BY id_pedido
),
por_pedido AS (
  SELECT r.id_pedido, i.valor_itens, COALESCE(g.recebido, 0) AS recebido
  FROM recorte r
  LEFT JOIN itens i ON i.id_pedido = r.id_pedido
  LEFT JOIN pagos g ON g.id_pedido = r.id_pedido
)
SELECT 'valor_itens <> recebido' AS comparacao,
       COUNT(*) FILTER (WHERE valor_itens <> recebido) AS pedidos_com_diferenca
FROM por_pedido
UNION ALL
SELECT 'ROUND(valor_itens - recebido, 2) <> 0',
       COUNT(*) FILTER (WHERE ROUND(valor_itens - recebido, 2) <> 0)
FROM por_pedido
