-- A mesma janela de 6 dias, mas ordenando pela data e hora do pedido, e não pelo dia.
-- Mostra os pedidos de 8 de janeiro. desde é o momento em que a janela de cada pedido começa.
WITH p AS (
    SELECT id_pedido, data_hora_pedido
    FROM pedidos
    WHERE status <> 'cancelado'
),
janela AS (
    SELECT id_pedido, data_hora_pedido,
           data_hora_pedido - INTERVAL 6 DAYS AS desde,
           COUNT(*) OVER (ORDER BY data_hora_pedido
                          RANGE BETWEEN INTERVAL 6 DAYS PRECEDING AND CURRENT ROW) AS pedidos_na_janela
    FROM p
)
SELECT id_pedido,
       strftime(data_hora_pedido, '%d/%m %H:%M:%S') AS pedido_em,
       strftime(desde, '%d/%m %H:%M:%S') AS desde,
       pedidos_na_janela
FROM janela
WHERE CAST(data_hora_pedido AS DATE) = DATE '2026-01-08'
ORDER BY data_hora_pedido;
