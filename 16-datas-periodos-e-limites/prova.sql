-- A prova de que nenhum pedido ficou de fora nem entrou duas vezes.
-- Para cada forma de escrever o intervalo, conta em quantos meses cada pedido entrou.
WITH meses AS (
    SELECT inicio, inicio + INTERVAL 1 MONTH AS fim,
           CAST(inicio + INTERVAL 1 MONTH - INTERVAL 1 DAY AS DATE) AS ultimo_dia
    FROM range(TIMESTAMP '2026-01-01', TIMESTAMP '2026-07-01', INTERVAL 1 MONTH) AS t(inicio)
),
por_pedido AS (
    SELECT p.id_pedido,
           COUNT(*) FILTER (WHERE p.data_hora_pedido BETWEEN m.inicio AND m.ultimo_dia) AS ate_ultimo_dia,
           COUNT(*) FILTER (WHERE p.data_hora_pedido BETWEEN m.inicio AND m.fim) AS ate_dia_1,
           COUNT(*) FILTER (WHERE p.data_hora_pedido >= m.inicio AND p.data_hora_pedido < m.fim) AS meio_aberto
    FROM pedidos AS p
    CROSS JOIN meses AS m
    GROUP BY p.id_pedido
),
formas AS (
    SELECT 'between ate o ultimo dia' AS forma, ate_ultimo_dia AS meses_do_pedido FROM por_pedido
    UNION ALL SELECT 'between ate o dia 1', ate_dia_1 FROM por_pedido
    UNION ALL SELECT 'meio aberto', meio_aberto FROM por_pedido
)
SELECT forma,
       COUNT(*) AS pedidos_na_base,
       SUM(meses_do_pedido) AS soma_dos_meses,
       COUNT(*) FILTER (WHERE meses_do_pedido = 0) AS em_nenhum_mes,
       COUNT(*) FILTER (WHERE meses_do_pedido > 1) AS em_dois_meses
FROM formas
GROUP BY forma
ORDER BY forma;
