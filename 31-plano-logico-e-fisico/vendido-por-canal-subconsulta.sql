-- A mesma pergunta, com o filtro numa subconsulta antes do JOIN.
SELECT p.canal,
       COUNT(DISTINCT p.id_pedido) AS pedidos,
       ROUND(SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)), 2) AS vendido
FROM (SELECT * FROM pedidos WHERE status = 'entregue') p
JOIN itens_pedido i ON i.id_pedido = p.id_pedido
GROUP BY p.canal
ORDER BY p.canal;
