-- Quantos pedidos cada lista tem, e quem está numa e não na outra.
WITH numerados AS (
    SELECT id_pedido, status,
           ROW_NUMBER() OVER (PARTITION BY id_pedido
                              ORDER BY data_hora_pagamento DESC, id_pagamento DESC) AS ordem
    FROM pagamentos
),
caio AS (
    SELECT id_pedido FROM numerados WHERE ordem = 1 AND status = 'aprovado'
),
aprovados AS (
    SELECT id_pedido,
           ROW_NUMBER() OVER (PARTITION BY id_pedido
                              ORDER BY data_hora_pagamento DESC, id_pagamento DESC) AS ordem
    FROM pagamentos
    WHERE status = 'aprovado'
),
certo AS (
    SELECT id_pedido FROM aprovados WHERE ordem = 1
)
SELECT 'lista do Caio' AS o_que, COUNT(*) AS pedidos FROM caio
UNION ALL
SELECT 'filtro antes da janela', COUNT(*) FROM certo
UNION ALL
SELECT 'na segunda e não na do Caio', COUNT(*) FROM (SELECT id_pedido FROM certo EXCEPT SELECT id_pedido FROM caio)
UNION ALL
SELECT 'na do Caio e não na segunda', COUNT(*) FROM (SELECT id_pedido FROM caio EXCEPT SELECT id_pedido FROM certo);
