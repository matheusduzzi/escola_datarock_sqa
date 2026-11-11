-- A janela certa: o dia e os 6 anteriores. RANGE com INTERVAL 6 DAYS PRECEDING.
-- Uma linha por dia, de 1º a 21 de janeiro. primeiro_dia é o dia mais antigo que tem pedido na janela.
WITH p AS (
    SELECT id_pedido, CAST(data_hora_pedido AS DATE) AS dia
    FROM pedidos
    WHERE status <> 'cancelado'
),
janela AS (
    SELECT dia,
           COUNT(*) OVER (PARTITION BY dia) AS pedidos_no_dia,
           MIN(dia) OVER w AS primeiro_dia,
           COUNT(*) OVER w AS pedidos_7_dias
    FROM p
    WINDOW w AS (ORDER BY dia RANGE BETWEEN INTERVAL 6 DAYS PRECEDING AND CURRENT ROW)
)
SELECT DISTINCT dia, pedidos_no_dia, primeiro_dia, pedidos_7_dias
FROM janela
WHERE dia <= DATE '2026-01-21'
ORDER BY dia;
