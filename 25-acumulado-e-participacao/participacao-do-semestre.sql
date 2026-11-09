-- Participação com o denominador errado: cada valor dividido pelo total do semestre.
-- Depois soma as participações de cada mês.
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
    SELECT mes, categoria,
           100 * valor / SUM(valor) OVER () AS pct
    FROM vendas
)
SELECT mes, ROUND(SUM(pct), 1) AS soma_das_participacoes
FROM com_participacao
GROUP BY mes
ORDER BY mes;
