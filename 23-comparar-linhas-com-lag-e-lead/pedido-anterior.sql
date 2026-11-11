-- As compras de um cliente, uma por linha, com a compra de cima (LAG) e a de baixo (LEAD).
-- Compra é pedido não cancelado. Mostra o cliente 11.
WITH compras AS (
  SELECT id_cliente, id_pedido, CAST(data_hora_pedido AS DATE) AS dia
  FROM pedidos
  WHERE status <> 'cancelado'
),
vizinhas AS (
  SELECT id_cliente, id_pedido, dia,
         LAG(dia) OVER (PARTITION BY id_cliente ORDER BY dia, id_pedido) AS compra_anterior,
         LEAD(dia) OVER (PARTITION BY id_cliente ORDER BY dia, id_pedido) AS proxima_compra
  FROM compras
)
SELECT id_pedido, dia, compra_anterior,
       date_diff('day', compra_anterior, dia) AS dias_desde_a_anterior,
       proxima_compra,
       date_diff('day', dia, proxima_compra) AS dias_ate_a_proxima
FROM vizinhas
WHERE id_cliente = 11
ORDER BY dia, id_pedido;
