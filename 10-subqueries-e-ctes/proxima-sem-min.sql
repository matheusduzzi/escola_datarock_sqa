-- A etapa proxima sem o MIN: a subquery tenta trazer todas as compras seguintes de uma vez.
WITH compras AS (
    SELECT id_pedido,
           id_cliente,
           CAST(data_hora_pedido AS DATE) AS dia
    FROM pedidos
    WHERE status IN ('entregue', 'em_andamento')
),
compra_marco AS (
    SELECT id_cliente,
           MIN(dia) AS dia_marco
    FROM compras
    WHERE dia >= DATE '2026-03-01'
      AND dia <  DATE '2026-04-01'
    GROUP BY id_cliente
)
SELECT m.id_cliente,
       m.dia_marco,
       (SELECT c.dia
        FROM compras c
        WHERE c.id_cliente = m.id_cliente
          AND c.dia > m.dia_marco) AS dia_proxima
FROM compra_marco m;
