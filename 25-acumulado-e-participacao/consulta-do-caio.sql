-- A consulta que o Caio mandou para a Bruna: pedidos entregues por canal e mês,
-- com o acumulado de pedidos de cada canal e a participação de cada canal.
SELECT strftime(p.data_hora_pedido, '%Y-%m') AS mes,
       p.canal,
       COUNT(*) AS pedidos,
       SUM(COUNT(*)) OVER (PARTITION BY p.canal ORDER BY strftime(p.data_hora_pedido, '%Y-%m')) AS pedidos_acumulados,
       ROUND(SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)), 2) AS faturamento,
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_pedidos,
       ROUND(100 * SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0))
             / SUM(SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0))) OVER (PARTITION BY strftime(p.data_hora_pedido, '%Y-%m')), 1) AS pct_faturamento
FROM pedidos p
JOIN itens_pedido i USING (id_pedido)
WHERE p.status = 'entregue'
GROUP BY 1, 2
ORDER BY 1, 2;
