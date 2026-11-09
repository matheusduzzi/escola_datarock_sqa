-- O status aprovado no QUALIFY, junto com a janela, em vez de no WHERE.
SELECT id_pedido, id_pagamento, data_hora_pagamento, forma, valor
FROM pagamentos
QUALIFY ROW_NUMBER() OVER (PARTITION BY id_pedido
                           ORDER BY data_hora_pagamento DESC, id_pagamento DESC) = 1
    AND status = 'aprovado'
ORDER BY id_pedido;
