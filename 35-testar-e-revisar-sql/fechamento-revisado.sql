-- Fechamento parcial de junho, revisado.
-- Recorte: pedidos não cancelados feitos de 01/06 00:00 até antes de 21/06 00:00.
-- Cada fato é somado por pedido antes de juntar (itens, entregas, pagamentos).
WITH recorte AS (
  SELECT id_pedido
  FROM pedidos
  WHERE status <> 'cancelado'
    AND data_hora_pedido >= TIMESTAMP '2026-06-01 00:00:00'
    AND data_hora_pedido <  TIMESTAMP '2026-06-21 00:00:00'
),
itens AS (
  SELECT id_pedido, SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS valor_itens
  FROM itens_pedido GROUP BY id_pedido
),
fretes AS (
  SELECT id_pedido,
         SUM(custo_frete) AS frete,
         COUNT(*) - COUNT(custo_frete) AS entregas_sem_fatura
  FROM entregas GROUP BY id_pedido
),
pagos AS (
  SELECT id_pedido, SUM(valor) AS recebido
  FROM pagamentos WHERE status = 'aprovado' GROUP BY id_pedido
),
por_pedido AS (
  SELECT r.id_pedido, i.valor_itens, f.frete, f.entregas_sem_fatura,
         COALESCE(g.recebido, 0) AS recebido
  FROM recorte r
  LEFT JOIN itens i  ON i.id_pedido = r.id_pedido
  LEFT JOIN fretes f ON f.id_pedido = r.id_pedido
  LEFT JOIN pagos g  ON g.id_pedido = r.id_pedido
)
SELECT COUNT(*) AS pedidos,
       ROUND(SUM(valor_itens), 2) AS faturamento,
       ROUND(SUM(frete), 2) AS frete,
       SUM(entregas_sem_fatura) AS entregas_sem_fatura,
       ROUND(SUM(recebido), 2) AS recebido,
       ROUND(SUM(valor_itens - recebido), 2) AS a_receber
FROM por_pedido
