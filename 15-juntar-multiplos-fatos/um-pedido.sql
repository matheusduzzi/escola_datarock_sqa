-- O pedido 548 juntado direto: cada item com cada pagamento com cada entrega.
SELECT i.n_item,
       i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0) AS valor_item,
       g.id_pagamento,
       g.forma,
       g.valor                                                   AS valor_pago,
       e.volume,
       e.resultado
FROM itens_pedido i
JOIN pagamentos g ON g.id_pedido = i.id_pedido
JOIN entregas e ON e.id_pedido = i.id_pedido
WHERE i.id_pedido = 548
ORDER BY i.n_item, g.id_pagamento, e.volume;
