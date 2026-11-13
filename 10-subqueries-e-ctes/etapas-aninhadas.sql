-- Recompra em até 30 dias dos clientes que compraram em março, com uma subquery dentro da outra.
-- Leia de dentro para fora: a mais funda acha a compra de março de cada cliente,
-- a do meio acha a compra seguinte, a de fora conta.
SELECT COUNT(*)                                                AS clientes_marco,
       COUNT(*) FILTER (WHERE dia_proxima <= dia_marco + 30)   AS voltaram_30_dias,
       ROUND(100.0 * COUNT(*) FILTER (WHERE dia_proxima <= dia_marco + 30) / COUNT(*), 1) AS pct
FROM (
    SELECT m.id_cliente,
           m.dia_marco,
           (SELECT MIN(CAST(p.data_hora_pedido AS DATE))
            FROM pedidos p
            WHERE p.id_cliente = m.id_cliente
              AND p.status IN ('entregue', 'em_andamento')
              AND CAST(p.data_hora_pedido AS DATE) > m.dia_marco) AS dia_proxima
    FROM (
        SELECT id_cliente,
               MIN(CAST(data_hora_pedido AS DATE)) AS dia_marco
        FROM pedidos
        WHERE status IN ('entregue', 'em_andamento')
          AND data_hora_pedido >= TIMESTAMP '2026-03-01'
          AND data_hora_pedido <  TIMESTAMP '2026-04-01'
        GROUP BY id_cliente
    ) AS m
) AS proxima;
