-- Recompra em até 30 dias dos clientes que compraram em março, em etapas com nome.
-- 1. compras: uma linha por pedido que conta como compra (entregue ou em andamento).
WITH compras AS (
    SELECT id_pedido,
           id_cliente,
           CAST(data_hora_pedido AS DATE) AS dia
    FROM pedidos
    WHERE status IN ('entregue', 'em_andamento')
),
-- 2. compra_marco: uma linha por cliente que comprou em março, com o dia da primeira compra do mês.
compra_marco AS (
    SELECT id_cliente,
           MIN(dia) AS dia_marco
    FROM compras
    WHERE dia >= DATE '2026-03-01'
      AND dia <  DATE '2026-04-01'
    GROUP BY id_cliente
),
-- 3. proxima: uma linha por cliente de março, com o dia da compra seguinte. Vazio se ele não voltou.
proxima AS (
    SELECT m.id_cliente,
           m.dia_marco,
           (SELECT MIN(c.dia)
            FROM compras c
            WHERE c.id_cliente = m.id_cliente
              AND c.dia > m.dia_marco) AS dia_proxima
    FROM compra_marco m
)
-- 4. A resposta: uma linha só.
SELECT COUNT(*)                                                AS clientes_marco,
       COUNT(*) FILTER (WHERE dia_proxima <= dia_marco + 30)   AS voltaram_30_dias,
       ROUND(100.0 * COUNT(*) FILTER (WHERE dia_proxima <= dia_marco + 30) / COUNT(*), 1) AS pct
FROM proxima;
