-- Acumulado de pedidos por dia, ordenando só pela data (sem hora).
-- Os pedidos do mesmo dia empatam na ordem. Mostra os 2 primeiros dias.
WITH pedidos_do_ano AS (
    SELECT id_pedido, CAST(data_hora_pedido AS DATE) AS dia
    FROM pedidos
    WHERE status <> 'cancelado'
),
janela AS (
    SELECT id_pedido, dia,
           COUNT(*) OVER (ORDER BY dia) AS com_range,
           COUNT(*) OVER (ORDER BY dia, id_pedido ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS com_desempate
    FROM pedidos_do_ano
)
SELECT id_pedido, dia, com_range, com_desempate
FROM janela
WHERE dia <= DATE '2026-01-03'
ORDER BY dia, id_pedido;
