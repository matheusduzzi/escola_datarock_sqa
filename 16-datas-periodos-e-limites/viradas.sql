-- Os pedidos feitos na última hora de um mês ou na primeira hora do mês seguinte,
-- e em quantos meses cada um entra em cada forma de escrever o intervalo.
WITH meses AS (
    SELECT inicio, inicio + INTERVAL 1 MONTH AS fim,
           CAST(inicio + INTERVAL 1 MONTH - INTERVAL 1 DAY AS DATE) AS ultimo_dia
    FROM range(TIMESTAMP '2026-01-01', TIMESTAMP '2026-07-01', INTERVAL 1 MONTH) AS t(inicio)
)
SELECT p.id_pedido, p.data_hora_pedido,
       COUNT(*) FILTER (WHERE p.data_hora_pedido BETWEEN m.inicio AND m.ultimo_dia) AS ate_ultimo_dia,
       COUNT(*) FILTER (WHERE p.data_hora_pedido BETWEEN m.inicio AND m.fim) AS ate_dia_1,
       COUNT(*) FILTER (WHERE p.data_hora_pedido >= m.inicio AND p.data_hora_pedido < m.fim) AS meio_aberto
FROM pedidos AS p
CROSS JOIN meses AS m
WHERE EXISTS (SELECT 1 FROM meses AS v
              WHERE p.data_hora_pedido >= v.fim - INTERVAL 1 HOUR
                AND p.data_hora_pedido < v.fim + INTERVAL 1 HOUR)
GROUP BY p.id_pedido, p.data_hora_pedido
ORDER BY p.data_hora_pedido;
