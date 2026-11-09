-- A lista do Caio: numera todos os pagamentos do pedido e só depois filtra o aprovado.
WITH numerados AS (
    SELECT id_pedido, id_pagamento, data_hora_pagamento, forma, valor, status,
           ROW_NUMBER() OVER (PARTITION BY id_pedido
                              ORDER BY data_hora_pagamento DESC, id_pagamento DESC) AS ordem
    FROM pagamentos
)
SELECT id_pedido, id_pagamento, data_hora_pagamento, forma, valor
FROM numerados
WHERE ordem = 1
  AND status = 'aprovado'
ORDER BY id_pedido;
