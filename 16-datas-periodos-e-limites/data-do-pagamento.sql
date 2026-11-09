-- Pedidos com pagamento aprovado num mês diferente do mês do pedido.
SELECT p.id_pedido, p.data_hora_pedido, g.data_hora_pagamento, g.valor
FROM pedidos AS p
JOIN pagamentos AS g ON g.id_pedido = p.id_pedido
WHERE g.status = 'aprovado'
  AND date_trunc('month', g.data_hora_pagamento) <> date_trunc('month', p.data_hora_pedido)
ORDER BY p.id_pedido;
