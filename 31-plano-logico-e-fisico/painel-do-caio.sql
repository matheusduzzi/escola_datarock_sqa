-- O painel da Lúcia como o Caio fez: uma consulta só, do CSV ao relatório.
-- Vendido e recebido por mês, só pedidos entregues.
SELECT strftime(p.data_hora_pedido, '%Y-%m') AS mes,
       COUNT(DISTINCT p.id_pedido) AS pedidos,
       ROUND(SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)), 2) AS vendido,
       ROUND(SUM(g.valor), 2) AS recebido
FROM pedidos p
JOIN itens_pedido i ON i.id_pedido = p.id_pedido
JOIN pagamentos g ON g.id_pedido = p.id_pedido AND g.status = 'aprovado'
WHERE p.status = 'entregue'
GROUP BY 1
ORDER BY 1;
