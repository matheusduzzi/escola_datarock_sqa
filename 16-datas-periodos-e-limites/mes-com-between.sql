-- Primeira tentativa: pedidos e valor por mês com BETWEEN do dia 1 ao último dia do mês.
-- A tabela de meses foi digitada à mão, com datas sem hora.
WITH meses AS (
    SELECT * FROM (VALUES
        ('2026-01', DATE '2026-01-01', DATE '2026-01-31'),
        ('2026-02', DATE '2026-02-01', DATE '2026-02-28'),
        ('2026-03', DATE '2026-03-01', DATE '2026-03-31'),
        ('2026-04', DATE '2026-04-01', DATE '2026-04-30'),
        ('2026-05', DATE '2026-05-01', DATE '2026-05-31'),
        ('2026-06', DATE '2026-06-01', DATE '2026-06-30')
    ) AS t(mes, primeiro_dia, ultimo_dia)
),
valor_pedido AS (
    SELECT id_pedido, SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS valor
    FROM itens_pedido
    GROUP BY id_pedido
)
SELECT m.mes, COUNT(p.id_pedido) AS pedidos, ROUND(SUM(v.valor), 2) AS valor
FROM meses AS m
LEFT JOIN pedidos AS p ON p.data_hora_pedido BETWEEN m.primeiro_dia AND m.ultimo_dia
LEFT JOIN valor_pedido AS v ON v.id_pedido = p.id_pedido
GROUP BY m.mes
ORDER BY m.mes;
