-- O Caio pôs o canal na etapa compra_marco para separar a recompra por canal.
WITH compras AS (
    SELECT id_pedido,
           id_cliente,
           canal,
           CAST(data_hora_pedido AS DATE) AS dia
    FROM pedidos
    WHERE status IN ('entregue', 'em_andamento')
),
compra_marco AS (
    SELECT id_cliente,
           canal,
           MIN(dia) AS dia_marco
    FROM compras
    WHERE dia >= DATE '2026-03-01'
      AND dia <  DATE '2026-04-01'
    GROUP BY id_cliente, canal
),
proxima AS (
    SELECT m.id_cliente,
           m.canal,
           m.dia_marco,
           (SELECT MIN(c.dia)
            FROM compras c
            WHERE c.id_cliente = m.id_cliente
              AND c.dia > m.dia_marco) AS dia_proxima
    FROM compra_marco m
)
SELECT canal,
       COUNT(*)                                              AS clientes_marco,
       COUNT(*) FILTER (WHERE dia_proxima <= dia_marco + 30) AS voltaram_30_dias
FROM proxima
GROUP BY canal
ORDER BY canal;
