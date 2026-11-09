-- O Rafael quer só os pedidos entregues. O filtro pode ir antes ou depois da janela?
WITH antes AS (
    -- O filtro do pedido entregue na etapa da janela.
    SELECT g.id_pedido, g.id_pagamento,
           ROW_NUMBER() OVER (PARTITION BY g.id_pedido
                              ORDER BY g.data_hora_pagamento DESC, g.id_pagamento DESC) AS ordem
    FROM pagamentos g
    JOIN pedidos p USING (id_pedido)
    WHERE g.status = 'aprovado'
      AND p.status = 'entregue'
),
aprovados AS (
    SELECT id_pedido, id_pagamento,
           ROW_NUMBER() OVER (PARTITION BY id_pedido
                              ORDER BY data_hora_pagamento DESC, id_pagamento DESC) AS ordem
    FROM pagamentos
    WHERE status = 'aprovado'
),
depois AS (
    -- O filtro do pedido entregue numa etapa depois da janela.
    SELECT a.id_pedido, a.id_pagamento
    FROM aprovados a
    JOIN pedidos p USING (id_pedido)
    WHERE a.ordem = 1
      AND p.status = 'entregue'
),
a1 AS (SELECT id_pedido, id_pagamento FROM antes WHERE ordem = 1)
SELECT 'filtro antes da janela' AS o_que, COUNT(*) AS pedidos FROM a1
UNION ALL SELECT 'filtro depois da janela', COUNT(*) FROM depois
UNION ALL SELECT 'linhas diferentes', COUNT(*) FROM ((SELECT * FROM a1 EXCEPT SELECT * FROM depois)
                                                     UNION ALL (SELECT * FROM depois EXCEPT SELECT * FROM a1));
