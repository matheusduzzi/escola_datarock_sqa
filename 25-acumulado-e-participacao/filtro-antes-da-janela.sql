-- Participação de Eletro no mês com o filtro antes da janela e depois dela.
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
filtro_antes AS (
    -- O WHERE roda antes da janela: o total do mês passa a ser só de Eletro.
    SELECT mes, 100 * valor / SUM(valor) OVER (PARTITION BY mes) AS pct
    FROM vendas
    WHERE categoria = 'Eletro'
),
todas AS (
    -- A janela roda com todas as categorias; o filtro vem na etapa seguinte.
    SELECT mes, categoria, 100 * valor / SUM(valor) OVER (PARTITION BY mes) AS pct
    FROM vendas
),
filtro_depois AS (
    SELECT mes, pct FROM todas WHERE categoria = 'Eletro'
)
SELECT a.mes, ROUND(a.pct, 1) AS pct_filtro_antes, ROUND(d.pct, 1) AS pct_filtro_depois
FROM filtro_antes a
JOIN filtro_depois d USING (mes)
ORDER BY a.mes;
