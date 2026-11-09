-- O último pagamento aprovado de cada pedido: o filtro do status vem antes da janela.
WITH aprovados AS (
    SELECT id_pedido, id_pagamento, data_hora_pagamento, forma, valor,
           ROW_NUMBER() OVER (PARTITION BY id_pedido
                              ORDER BY data_hora_pagamento DESC, id_pagamento DESC) AS ordem
    FROM pagamentos
    WHERE status = 'aprovado'
)
SELECT id_pedido, id_pagamento, data_hora_pagamento, forma, valor
FROM aprovados
WHERE ordem = 1
ORDER BY id_pedido;
