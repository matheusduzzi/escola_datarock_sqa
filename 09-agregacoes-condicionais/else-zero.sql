-- O ELSE 0 dentro do COUNT e do AVG, com uma linha por pedido.
WITH pedido AS (
    SELECT p.id_pedido,
           p.status,
           SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor
    FROM pedidos p
    JOIN itens_pedido i ON i.id_pedido = p.id_pedido
    GROUP BY p.id_pedido, p.status
)
SELECT COUNT(CASE WHEN status = 'devolvido' THEN 1 ELSE 0 END)             AS count_else_0,
       COUNT(CASE WHEN status = 'devolvido' THEN 1 END)                    AS count_sem_else,
       SUM(CASE WHEN status = 'devolvido' THEN 1 ELSE 0 END)               AS sum_else_0,
       ROUND(AVG(CASE WHEN status = 'devolvido' THEN valor ELSE 0 END), 2) AS avg_else_0,
       ROUND(AVG(CASE WHEN status = 'devolvido' THEN valor END), 2)        AS avg_sem_else,
       ROUND(AVG(valor) FILTER (WHERE status = 'devolvido'), 2)            AS avg_filter
FROM pedido;
