-- Participação de cada categoria no faturamento do mês: o denominador é o total do mês.
-- Mostra janeiro e abril.
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
com_participacao AS (
    SELECT mes, categoria, valor,
           SUM(valor) OVER (PARTITION BY mes) AS total_do_mes,
           100 * valor / SUM(valor) OVER (PARTITION BY mes) AS pct_no_mes
    FROM vendas
)
SELECT mes, categoria, ROUND(valor, 2) AS valor, ROUND(total_do_mes, 2) AS total_do_mes,
       ROUND(pct_no_mes, 1) AS pct_no_mes
FROM com_participacao
WHERE mes IN ('2026-01', '2026-04')
ORDER BY mes, categoria;
