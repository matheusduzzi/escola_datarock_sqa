-- Conciliação de março, como a Lívia mandou.
-- Pedidos entregues feitos em março: valor dos itens e o que foi aprovado em pagamento até 31/03.
WITH conciliacao AS (
  SELECT p.id_pedido,
         SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor_itens,
         SUM(g.valor) AS recebido_em_marco
  FROM pedidos p
  JOIN itens_pedido i ON i.id_pedido = p.id_pedido
  LEFT JOIN pagamentos g ON g.id_pedido = p.id_pedido
       AND g.status = 'aprovado'
       AND g.data_hora_pagamento < '2026-04-01'
  WHERE p.status = 'entregue'
    AND p.data_hora_pedido BETWEEN '2026-03-01' AND '2026-04-01'
  GROUP BY p.id_pedido
)
SELECT COUNT(*) AS pedidos,
       ROUND(SUM(valor_itens), 2) AS valor_itens,
       ROUND(SUM(recebido_em_marco), 2) AS recebido_em_marco,
       COUNT(*) FILTER (WHERE valor_itens <> recebido_em_marco) AS pedidos_com_diferenca
FROM conciliacao
