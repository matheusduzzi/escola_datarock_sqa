-- O histórico de pagamento de quatro pedidos, na ordem em que aconteceu.
SELECT id_pedido, id_pagamento, data_hora_pagamento, forma, valor, status
FROM pagamentos
WHERE id_pedido IN (20, 31, 283, 882)
ORDER BY id_pedido, data_hora_pagamento, id_pagamento;
