-- Participação de Eletro no semestre: a média das participações mensais
-- contra o total de Eletro dividido pelo total do semestre.
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
mensal AS (
    SELECT mes, categoria, 100 * valor / SUM(valor) OVER (PARTITION BY mes) AS pct
    FROM vendas
),
semestre AS (
    SELECT categoria, 100 * SUM(valor) / SUM(SUM(valor)) OVER () AS pct
    FROM vendas
    GROUP BY categoria
)
SELECT s.categoria,
       ROUND(AVG(m.pct), 1) AS media_das_participacoes,
       ROUND(s.pct, 1) AS participacao_no_semestre
FROM semestre s
JOIN mensal m USING (categoria)
GROUP BY s.categoria, s.pct
ORDER BY s.categoria;
