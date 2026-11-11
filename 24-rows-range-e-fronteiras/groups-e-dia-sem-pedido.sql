-- RANGE e GROUPS lado a lado, de 14 a 21 de janeiro. O dia 15 não tem pedido.
-- GROUPS conta grupos de pedidos empatados no dia, e não dias do calendário.
WITH p AS (
    SELECT id_pedido, CAST(data_hora_pedido AS DATE) AS dia
    FROM pedidos
    WHERE status <> 'cancelado'
),
janela AS (
    SELECT dia,
           COUNT(*) OVER (ORDER BY dia RANGE BETWEEN INTERVAL 6 DAYS PRECEDING AND CURRENT ROW) AS com_range,
           MIN(dia) OVER (ORDER BY dia GROUPS BETWEEN 6 PRECEDING AND CURRENT ROW) AS groups_desde,
           COUNT(*) OVER (ORDER BY dia GROUPS BETWEEN 6 PRECEDING AND CURRENT ROW) AS com_groups
    FROM p
)
SELECT DISTINCT dia, com_range, groups_desde, com_groups
FROM janela
WHERE dia BETWEEN DATE '2026-01-14' AND DATE '2026-01-21'
ORDER BY dia;
