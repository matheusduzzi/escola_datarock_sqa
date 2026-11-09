-- Segunda tentativa: BETWEEN do dia 1 até o dia 1 do mês seguinte.
WITH meses AS (
    SELECT * FROM (VALUES
        ('2026-01', DATE '2026-01-01', DATE '2026-02-01'),
        ('2026-02', DATE '2026-02-01', DATE '2026-03-01'),
        ('2026-03', DATE '2026-03-01', DATE '2026-04-01'),
        ('2026-04', DATE '2026-04-01', DATE '2026-05-01'),
        ('2026-05', DATE '2026-05-01', DATE '2026-06-01'),
        ('2026-06', DATE '2026-06-01', DATE '2026-07-01')
    ) AS t(mes, inicio, fim)
),
valor_pedido AS (
    SELECT id_pedido, SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS valor
    FROM itens_pedido
    GROUP BY id_pedido
)
SELECT m.mes, COUNT(p.id_pedido) AS pedidos, ROUND(SUM(v.valor), 2) AS valor
FROM meses AS m
LEFT JOIN pedidos AS p ON p.data_hora_pedido BETWEEN m.inicio AND m.fim
LEFT JOIN valor_pedido AS v ON v.id_pedido = p.id_pedido
GROUP BY m.mes
ORDER BY m.mes;
