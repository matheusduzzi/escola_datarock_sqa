-- O JOIN do Diego antes do GROUP BY: quantas linhas cada pedido ganhou.
-- Mostra os cinco pedidos com mais linhas e quantos itens, entregas e pagamentos cada um tem.
WITH juntado AS (
  SELECT p.id_pedido
  FROM pedidos p
  JOIN itens_pedido i ON i.id_pedido = p.id_pedido
  LEFT JOIN entregas e ON e.id_pedido = p.id_pedido
  LEFT JOIN pagamentos g ON g.id_pedido = p.id_pedido AND g.status = 'aprovado'
  WHERE p.status <> 'cancelado'
    AND p.data_hora_pedido BETWEEN '2026-06-01' AND '2026-06-20'
)
SELECT j.id_pedido,
       COUNT(*) AS linhas_no_join,
       (SELECT COUNT(*) FROM itens_pedido i WHERE i.id_pedido = j.id_pedido) AS itens,
       (SELECT COUNT(*) FROM entregas e WHERE e.id_pedido = j.id_pedido) AS entregas,
       (SELECT COUNT(*) FROM pagamentos g WHERE g.id_pedido = j.id_pedido AND g.status = 'aprovado') AS pagamentos
FROM juntado j
GROUP BY j.id_pedido
ORDER BY linhas_no_join DESC, j.id_pedido
LIMIT 5
