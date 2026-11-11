-- O frete por mês e transportadora como o Caio fez para a Marta.
-- Ele começou copiando o FROM do painel da Lúcia. É a consulta do exercício.
SELECT strftime(e.data_tentativa, '%Y-%m') AS mes,
       e.transportadora,
       COUNT(*) AS viagens,
       ROUND(SUM(COALESCE(e.custo_frete, 0)), 2) AS frete
FROM pedidos p
JOIN itens_pedido i ON i.id_pedido = p.id_pedido
JOIN entregas e ON e.id_pedido = p.id_pedido
WHERE e.data_tentativa IS NOT NULL
GROUP BY 1, 2
ORDER BY 1, 2;
