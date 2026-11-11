-- A consulta do Caio: "os últimos 7" com ROWS, sobre uma linha por pedido.
-- Mostra os pedidos de 7 e 8 de janeiro.
WITH p AS (
    SELECT id_pedido, CAST(data_hora_pedido AS DATE) AS dia
    FROM pedidos
    WHERE status <> 'cancelado'
),
janela AS (
    SELECT id_pedido, dia,
           COUNT(*) OVER (ORDER BY dia, id_pedido
                          ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS pedidos_7_dias
    FROM p
)
SELECT id_pedido, dia, pedidos_7_dias
FROM janela
WHERE dia BETWEEN DATE '2026-01-07' AND DATE '2026-01-08'
ORDER BY dia, id_pedido;
