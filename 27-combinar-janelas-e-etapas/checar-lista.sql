-- Perguntas com resposta conhecida sobre a lista do Rafael.
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
, mais_recente AS (
    -- Conta feita de outro jeito, sem janela: a maior data entre os aprovados de cada pedido.
    SELECT id_pedido, MAX(data_hora_pagamento) AS maior_data
    FROM pagamentos
    WHERE status = 'aprovado'
    GROUP BY id_pedido
)
SELECT 'linhas da lista' AS o_que, COUNT(*) AS valor FROM lista
UNION ALL SELECT 'pedidos diferentes na lista', COUNT(DISTINCT id_pedido) FROM lista
UNION ALL SELECT 'pedidos na tabela pedidos', COUNT(*) FROM pedidos
UNION ALL SELECT 'com último aprovado', COUNT(pagamento_aprovado) FROM lista
UNION ALL SELECT 'pedidos com algum pagamento aprovado', COUNT(*) FROM pedidos p
    WHERE EXISTS (SELECT 1 FROM pagamentos g WHERE g.id_pedido = p.id_pedido AND g.status = 'aprovado')
UNION ALL SELECT 'último aprovado fora da maior data', COUNT(*) FROM lista l JOIN mais_recente m USING (id_pedido)
    WHERE l.aprovado_em <> m.maior_data
UNION ALL SELECT 'situação hoje: aprovado', COUNT(*) FROM lista WHERE situacao_hoje = 'aprovado'
UNION ALL SELECT 'situação hoje: estornado', COUNT(*) FROM lista WHERE situacao_hoje = 'estornado'
UNION ALL SELECT 'situação hoje: pendente', COUNT(*) FROM lista WHERE situacao_hoje = 'pendente'
UNION ALL SELECT 'situação hoje: sem pagamento', COUNT(*) FROM lista WHERE situacao_hoje = 'sem pagamento'
UNION ALL SELECT 'estornados com último aprovado', COUNT(*) FROM lista
    WHERE situacao_hoje = 'estornado' AND pagamento_aprovado IS NOT NULL;
