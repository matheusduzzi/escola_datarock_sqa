-- O frete de cada linha da tabela entregas, pelo mês em que o pedido foi feito e pelo mês da tentativa.
-- As linhas com tentativa vazia são volumes ainda na rua.
SELECT strftime(p.data_hora_pedido, '%Y-%m') AS mes_do_pedido,
       COALESCE(strftime(e.data_tentativa, '%Y-%m'), 'na rua') AS mes_da_tentativa,
       COUNT(*) AS linhas,
       ROUND(SUM(e.custo_frete), 2) AS frete
FROM entregas e
JOIN pedidos p USING (id_pedido)
WHERE p.data_hora_pedido >= TIMESTAMP '2026-04-01 00:00:00'
GROUP BY ALL
ORDER BY ALL;
