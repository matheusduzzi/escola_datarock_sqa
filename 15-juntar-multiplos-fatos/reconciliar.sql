-- A reconciliação do Rafael: para cada pedido, o que a loja tem a receber,
-- o que entrou de dinheiro e o que aconteceu com a entrega. Tudo somado por pedido antes do JOIN.
WITH itens AS (
    SELECT id_pedido,
           SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS valor_itens
    FROM itens_pedido
    GROUP BY id_pedido
),
pagos AS (
    SELECT id_pedido,
           SUM(CASE status WHEN 'aprovado' THEN valor
                           WHEN 'estornado' THEN -valor
                           ELSE 0 END)                  AS recebido,
           COUNT(*) FILTER (WHERE status = 'pendente')  AS pendentes
    FROM pagamentos
    GROUP BY id_pedido
),
viagens AS (
    SELECT id_pedido,
           COUNT(*)                                                         AS linhas,
           COUNT(DISTINCT volume) FILTER (WHERE tipo = 'ida')               AS volumes,
           COUNT(DISTINCT volume) FILTER (WHERE tipo = 'ida'
                                            AND resultado = 'entregue')     AS volumes_entregues,
           COUNT(*) FILTER (WHERE tipo = 'ida' AND resultado IS NULL)       AS na_rua,
           COUNT(*) FILTER (WHERE tipo = 'devolucao'
                              AND resultado = 'recebido_cd')                AS voltas
    FROM entregas
    GROUP BY id_pedido
),
por_pedido AS (
    SELECT p.id_pedido,
           p.status,
           it.valor_itens,
           -- Pedido cancelado ou devolvido não deve nada: o dinheiro tem que ter voltado.
           CASE WHEN p.status IN ('entregue', 'em_andamento') THEN it.valor_itens ELSE 0 END AS a_receber,
           COALESCE(pg.recebido, 0)  AS recebido,
           COALESCE(pg.pendentes, 0) AS pendentes,
           COALESCE(v.linhas, 0)     AS viagens,
           COALESCE(v.volumes, 0)    AS volumes,
           COALESCE(v.volumes_entregues, 0) AS volumes_entregues,
           COALESCE(v.na_rua, 0)     AS na_rua,
           COALESCE(v.voltas, 0)     AS voltas
    FROM pedidos p
    LEFT JOIN itens it  ON it.id_pedido = p.id_pedido
    LEFT JOIN pagos pg  ON pg.id_pedido = p.id_pedido
    LEFT JOIN viagens v ON v.id_pedido = p.id_pedido
),
situacao AS (
    SELECT *,
           CASE WHEN ROUND(recebido - a_receber, 2) = 0 THEN 'fecha'
                WHEN pendentes > 0 AND recebido = 0     THEN 'boleto em aberto'
                ELSE 'diferença' END AS dinheiro,
           CASE status
                WHEN 'entregue'     THEN volumes > 0 AND volumes_entregues = volumes AND voltas = 0
                WHEN 'devolvido'    THEN volumes > 0 AND volumes_entregues = volumes AND voltas = 1
                WHEN 'cancelado'    THEN viagens = 0
                WHEN 'em_andamento' THEN na_rua > 0
           END AS entrega_bate
    FROM por_pedido
)
SELECT status,
       dinheiro,
       COUNT(*)                                       AS pedidos,
       ROUND(SUM(a_receber), 2)                       AS a_receber,
       ROUND(SUM(recebido), 2)                        AS recebido,
       COUNT(*) FILTER (WHERE entrega_bate)           AS entrega_bate,
       COUNT(*) FILTER (WHERE NOT entrega_bate)       AS entrega_nao_bate
FROM situacao
GROUP BY status, dinheiro
ORDER BY status, dinheiro;
