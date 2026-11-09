-- Faturamento de cada categoria em cada mês: a tabela de partida da aula.
-- Venda conta pelo mês do pedido. Pedido cancelado fica de fora.
SELECT strftime(p.data_hora_pedido, '%Y-%m') AS mes,
       d.categoria,
       ROUND(SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)), 2) AS valor
FROM pedidos p
JOIN itens_pedido i USING (id_pedido)
JOIN produtos d USING (id_produto)
WHERE p.status <> 'cancelado'
GROUP BY 1, 2
ORDER BY 1, 2;
