-- A primeira tentativa: numerar e filtrar na mesma consulta. O DuckDB recusa.
SELECT id_pedido, forma, valor, data_hora_pagamento
FROM pagamentos
WHERE status = 'aprovado'
  AND ROW_NUMBER() OVER (PARTITION BY id_pedido ORDER BY data_hora_pagamento DESC, id_pagamento DESC) = 1;
