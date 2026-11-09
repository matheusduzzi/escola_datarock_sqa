-- O pedido 31 pagou em duas partes. O que a lista mostra dele, e quanto entrou de verdade.
WITH aprovados AS (
    SELECT id_pedido, id_pagamento, forma, valor,
           ROW_NUMBER() OVER (PARTITION BY id_pedido
                              ORDER BY data_hora_pagamento DESC, id_pagamento DESC) AS ordem,
           COUNT(*) OVER (PARTITION BY id_pedido) AS aprovados_no_pedido,
           SUM(valor) OVER (PARTITION BY id_pedido) AS soma_aprovada
    FROM pagamentos
    WHERE status = 'aprovado'
),
itens AS (
    SELECT id_pedido, ROUND(SUM(quantidade * preco_unitario - COALESCE(desconto, 0)), 2) AS valor_dos_itens
    FROM itens_pedido
    GROUP BY id_pedido
)
SELECT a.id_pedido, a.id_pagamento, a.forma, a.valor AS valor_na_lista,
       a.aprovados_no_pedido, ROUND(a.soma_aprovada, 2) AS soma_aprovada, i.valor_dos_itens,
       (SELECT COUNT(DISTINCT id_pedido) FROM aprovados WHERE aprovados_no_pedido > 1) AS pedidos_divididos
FROM aprovados a
JOIN itens i USING (id_pedido)
WHERE a.ordem = 1
  AND a.id_pedido = 31;
