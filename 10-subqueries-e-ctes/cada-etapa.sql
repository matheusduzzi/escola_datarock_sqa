-- As mesmas etapas do etapas-cte.sql. No fim, quantas linhas cada etapa tem, e quantos pedidos e clientes diferentes.
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
-- Cada número sai de uma subquery escalar: uma consulta que retorna um valor só.
SELECT (SELECT COUNT(*) FROM compras)                    AS linhas_compras,
       (SELECT COUNT(DISTINCT id_pedido) FROM compras)   AS pedidos_compras,
       (SELECT COUNT(*) FROM compra_marco)               AS linhas_compra_marco,
       (SELECT COUNT(DISTINCT id_cliente) FROM compra_marco) AS clientes_compra_marco,
       (SELECT COUNT(*) FROM proxima)                    AS linhas_proxima,
       (SELECT COUNT(*) FROM proxima WHERE dia_proxima IS NULL) AS nunca_voltaram;
