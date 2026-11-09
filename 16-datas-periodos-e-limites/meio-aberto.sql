-- Pedidos e valor por mês com o intervalo meio aberto:
-- o começo entra (>=) e o fim, que é o começo do mês seguinte, não entra (<).
-- A tabela de meses sai do range(), e não digitada à mão.
WITH meses AS (
    SELECT inicio, inicio + INTERVAL 1 MONTH AS fim
    FROM range(TIMESTAMP '2026-01-01', TIMESTAMP '2026-07-01', INTERVAL 1 MONTH) AS t(inicio)
),
valor_pedido AS (
    SELECT id_pedido, SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS valor
    FROM itens_pedido
    GROUP BY id_pedido
)
SELECT strftime(m.inicio, '%Y-%m') AS mes, COUNT(p.id_pedido) AS pedidos, ROUND(SUM(v.valor), 2) AS valor
FROM meses AS m
LEFT JOIN pedidos AS p ON p.data_hora_pedido >= m.inicio AND p.data_hora_pedido < m.fim
LEFT JOIN valor_pedido AS v ON v.id_pedido = p.id_pedido
GROUP BY m.inicio
ORDER BY m.inicio;
