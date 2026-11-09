-- O último aprovado com QUALIFY, do DuckDB: o WHERE roda antes da janela e o QUALIFY depois.
SELECT id_pedido, id_pagamento, data_hora_pagamento, forma, valor
FROM pagamentos
WHERE status = 'aprovado'
QUALIFY ROW_NUMBER() OVER (PARTITION BY id_pedido
                           ORDER BY data_hora_pagamento DESC, id_pagamento DESC) = 1
ORDER BY id_pedido;
