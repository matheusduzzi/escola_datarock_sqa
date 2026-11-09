-- A lista do Rafael, só para alguns pedidos. O filtro dos pedidos fica na última etapa,
-- depois das duas janelas, e não muda o que elas viram.
WITH todos AS (
    -- Etapa 1: a janela vê todos os pagamentos do pedido.
    SELECT id_pedido, status,
           ROW_NUMBER() OVER (PARTITION BY id_pedido
                              ORDER BY data_hora_pagamento DESC, id_pagamento DESC) AS ordem
    FROM pagamentos
),
situacao AS (
    -- Etapa 2: fica o último registro de cada pedido, de qualquer status.
    SELECT id_pedido, status AS situacao_hoje FROM todos WHERE ordem = 1
),
aprovados AS (
    -- Etapa 3: a outra janela só vê os pagamentos aprovados.
    SELECT id_pedido, id_pagamento, data_hora_pagamento, forma, valor,
           ROW_NUMBER() OVER (PARTITION BY id_pedido
                              ORDER BY data_hora_pagamento DESC, id_pagamento DESC) AS ordem
    FROM pagamentos
    WHERE status = 'aprovado'
),
ultimo_aprovado AS (
    -- Etapa 4: fica o último aprovado de cada pedido.
    SELECT id_pedido, id_pagamento, data_hora_pagamento, forma, valor FROM aprovados WHERE ordem = 1
),
lista AS (
    -- Etapa 5: uma linha por pedido, com ou sem pagamento.
    SELECT p.id_pedido, p.status AS status_pedido,
           a.id_pagamento AS pagamento_aprovado, a.data_hora_pagamento AS aprovado_em, a.forma, a.valor,
           COALESCE(s.situacao_hoje, 'sem pagamento') AS situacao_hoje
    FROM pedidos p
    LEFT JOIN ultimo_aprovado a USING (id_pedido)
    LEFT JOIN situacao s USING (id_pedido)
)
SELECT * FROM lista
WHERE id_pedido IN (13, 20, 31, 58, 67, 283, 882)
ORDER BY id_pedido;
