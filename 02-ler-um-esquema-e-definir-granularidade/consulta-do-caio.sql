-- A consulta que o Caio mandou: valor pago aprovado, juntando pedidos, itens e pagamentos.
SELECT COUNT(*) AS linhas,
       ROUND(SUM(g.valor), 2) AS valor_pago
FROM pedidos p
JOIN itens_pedido i ON i.id_pedido = p.id_pedido
JOIN pagamentos g ON g.id_pedido = p.id_pedido
WHERE g.status = 'aprovado';
