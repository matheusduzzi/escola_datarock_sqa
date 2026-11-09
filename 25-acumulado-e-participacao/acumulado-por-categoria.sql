-- Acumulado de cada categoria: PARTITION BY categoria, ORDER BY mes.
-- Mostra Eletro e Esporte.
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
com_acumulado AS (
    SELECT mes, categoria, valor,
           SUM(valor) OVER (PARTITION BY categoria ORDER BY mes) AS acumulado
    FROM vendas
)
SELECT categoria, mes, ROUND(valor, 2) AS valor, ROUND(acumulado, 2) AS acumulado
FROM com_acumulado
WHERE categoria IN ('Eletro', 'Esporte')
ORDER BY categoria, mes;
