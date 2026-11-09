-- O remendo que a IA costuma sugerir: manter o JOIN direto e trocar SUM por SUM(DISTINCT).
-- Compare com o recebido certo, somado na tabela de pagamentos sozinha.
WITH remendo AS (
    SELECT p.id_pedido,
           SUM(DISTINCT CASE g.status WHEN 'aprovado' THEN g.valor
                                      WHEN 'estornado' THEN -g.valor
                                      ELSE 0 END) AS recebido_distinct
    FROM pedidos p
    JOIN itens_pedido i ON i.id_pedido = p.id_pedido
    LEFT JOIN pagamentos g ON g.id_pedido = p.id_pedido
    LEFT JOIN entregas e ON e.id_pedido = p.id_pedido
    GROUP BY p.id_pedido
),
certo AS (
    SELECT id_pedido,
           SUM(CASE status WHEN 'aprovado' THEN valor
                           WHEN 'estornado' THEN -valor
                           ELSE 0 END) AS recebido
    FROM pagamentos
    GROUP BY id_pedido
)
SELECT r.id_pedido,
       c.recebido,
       r.recebido_distinct
FROM remendo r
JOIN certo c ON c.id_pedido = r.id_pedido
WHERE ROUND(r.recebido_distinct - c.recebido, 2) <> 0
ORDER BY r.id_pedido;
