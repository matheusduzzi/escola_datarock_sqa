-- Os pedidos que têm pagamento aprovado e ficaram fora da lista do Caio:
-- qual foi o último registro deles e o status do pedido.
WITH numerados AS (
    SELECT id_pedido, status,
           ROW_NUMBER() OVER (PARTITION BY id_pedido
                              ORDER BY data_hora_pagamento DESC, id_pagamento DESC) AS ordem
    FROM pagamentos
),
ultimo AS (
    SELECT id_pedido, status AS status_do_ultimo FROM numerados WHERE ordem = 1
)
SELECT u.status_do_ultimo, p.status AS status_do_pedido, COUNT(*) AS pedidos
FROM ultimo u
JOIN pedidos p USING (id_pedido)
WHERE u.status_do_ultimo <> 'aprovado'
  AND EXISTS (SELECT 1 FROM pagamentos g WHERE g.id_pedido = u.id_pedido AND g.status = 'aprovado')
GROUP BY ALL
ORDER BY pedidos DESC;
