-- Esporte não vendeu nada em abril. Com a tabela de meses, abril aparece com 0
-- e o acumulado de abril repete o de março.
WITH vendas AS (
    SELECT strftime(p.data_hora_pedido, '%Y-%m') AS mes,
           d.categoria,
           SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor
    FROM pedidos p
    JOIN itens_pedido i USING (id_pedido)
    JOIN produtos d USING (id_produto)
    WHERE p.status <> 'cancelado'
    GROUP BY 1, 2
),
meses AS (
    SELECT strftime(inicio, '%Y-%m') AS mes
    FROM range(DATE '2026-01-01', DATE '2026-07-01', INTERVAL 1 MONTH) AS t(inicio)
),
esporte AS (
    SELECT m.mes, COALESCE(v.valor, 0) AS valor
    FROM meses m
    LEFT JOIN vendas v ON v.mes = m.mes AND v.categoria = 'Esporte'
)
SELECT mes, ROUND(valor, 2) AS valor,
       ROUND(SUM(valor) OVER (ORDER BY mes), 2) AS acumulado
FROM esporte
ORDER BY mes;
