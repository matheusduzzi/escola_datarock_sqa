-- As duas listas lado a lado, só para os quatro pedidos do histórico.
-- O filtro dos quatro pedidos fica na última etapa, depois das janelas.
WITH numerados AS (
    SELECT id_pedido, id_pagamento, status,
           ROW_NUMBER() OVER (PARTITION BY id_pedido
                              ORDER BY data_hora_pagamento DESC, id_pagamento DESC) AS ordem
    FROM pagamentos
),
caio AS (
    SELECT id_pedido, id_pagamento FROM numerados WHERE ordem = 1 AND status = 'aprovado'
),
aprovados AS (
    SELECT id_pedido, id_pagamento,
           ROW_NUMBER() OVER (PARTITION BY id_pedido
                              ORDER BY data_hora_pagamento DESC, id_pagamento DESC) AS ordem
    FROM pagamentos
    WHERE status = 'aprovado'
),
certo AS (
    SELECT id_pedido, id_pagamento FROM aprovados WHERE ordem = 1
),
ultimo AS (
    SELECT id_pedido, id_pagamento, status FROM numerados WHERE ordem = 1
)
SELECT u.id_pedido, u.id_pagamento AS ultimo_registro, u.status AS status_do_ultimo,
       c.id_pagamento AS lista_do_caio, a.id_pagamento AS filtro_antes
FROM ultimo u
LEFT JOIN caio c USING (id_pedido)
LEFT JOIN certo a USING (id_pedido)
WHERE u.id_pedido IN (20, 31, 283, 882)
ORDER BY u.id_pedido;
