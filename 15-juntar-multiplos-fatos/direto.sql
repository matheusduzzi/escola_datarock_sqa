-- A consulta que chegou pronta: junta os quatro de uma vez e soma.
-- Uma linha por pedido, com o valor dos itens e o que entrou de dinheiro.
-- No fim, conta quantos pedidos entregues não fecham (recebido diferente do valor dos itens).
WITH juntado AS (
    SELECT p.id_pedido,
           p.status,
           SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor_itens,
           SUM(CASE g.status WHEN 'aprovado' THEN g.valor
                             WHEN 'estornado' THEN -g.valor
                             ELSE 0 END)                                AS recebido,
           COUNT(*)                                                     AS linhas
    FROM pedidos p
    JOIN itens_pedido i ON i.id_pedido = p.id_pedido
    LEFT JOIN pagamentos g ON g.id_pedido = p.id_pedido
    LEFT JOIN entregas e ON e.id_pedido = p.id_pedido
    GROUP BY p.id_pedido, p.status
)
SELECT SUM(linhas)                                 AS linhas_juntadas,
       COUNT(*)                                    AS pedidos,
       ROUND(SUM(valor_itens), 2)                  AS valor_itens,
       ROUND(SUM(recebido), 2)                     AS recebido,
       COUNT(*) FILTER (WHERE status = 'entregue') AS entregues,
       COUNT(*) FILTER (WHERE status = 'entregue'
                          AND ROUND(recebido - valor_itens, 2) <> 0) AS entregues_sem_fechar
FROM juntado;
