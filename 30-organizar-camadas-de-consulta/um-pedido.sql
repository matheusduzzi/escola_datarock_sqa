-- O pedido 680, de maio, na consulta do Caio: as linhas que o JOIN monta antes do GROUP BY.
SELECT p.id_pedido, i.n_item,
       i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0) AS valor_item,
       g.id_pagamento, g.valor AS valor_pagamento
FROM pedidos p
JOIN itens_pedido i ON i.id_pedido = p.id_pedido
JOIN pagamentos g ON g.id_pedido = p.id_pedido AND g.status = 'aprovado'
WHERE p.id_pedido = 680
ORDER BY i.n_item, g.id_pagamento;
