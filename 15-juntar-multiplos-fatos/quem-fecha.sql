-- Por que a consulta direta acusou uns pedidos e deixou passar outros.
-- Para cada pedido entregue: quantas linhas ele vira no JOIN direto e se o número de itens
-- é igual ao número de pagamentos.
WITH contas AS (
    SELECT p.id_pedido,
           (SELECT COUNT(*) FROM itens_pedido i WHERE i.id_pedido = p.id_pedido) AS itens,
           (SELECT COUNT(*) FROM pagamentos g WHERE g.id_pedido = p.id_pedido)   AS pagamentos,
           (SELECT COUNT(*) FROM entregas e WHERE e.id_pedido = p.id_pedido)     AS entregas
    FROM pedidos p
    WHERE p.status = 'entregue'
)
SELECT CASE WHEN itens * pagamentos * entregas = 1 THEN 'não multiplica'
            ELSE 'multiplica' END                                   AS no_join_direto,
       CASE WHEN itens = pagamentos THEN 'itens = pagamentos'
            ELSE 'itens diferente de pagamentos' END                AS contagem,
       COUNT(*)                                                     AS pedidos
FROM contas
GROUP BY 1, 2
ORDER BY 1 DESC, 2 DESC;
