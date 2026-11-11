-- As premissas do modelo de análise do frete, rodadas sobre a base inteira.
-- Cada linha diz o que o modelo supõe e quantos casos contrariam. O modelo vale enquanto todas dão 0.
SELECT 'pedido com mais de uma transportadora' AS premissa, COUNT(*) AS casos_contra
FROM (SELECT id_pedido FROM entregas GROUP BY id_pedido HAVING COUNT(DISTINCT transportadora) > 1)
UNION ALL
SELECT 'pedido cancelado com linha em entregas', COUNT(DISTINCT e.id_pedido)
FROM entregas e JOIN pedidos p USING (id_pedido) WHERE p.status = 'cancelado'
UNION ALL
SELECT 'pedido não cancelado sem linha em entregas', COUNT(*)
FROM pedidos p
WHERE p.status <> 'cancelado' AND NOT EXISTS (SELECT 1 FROM entregas e WHERE e.id_pedido = p.id_pedido)
UNION ALL
SELECT 'pedido devolvido sem exatamente uma devolução', COUNT(*)
FROM pedidos p
WHERE p.status = 'devolvido'
  AND (SELECT COUNT(*) FROM entregas e WHERE e.id_pedido = p.id_pedido AND e.tipo = 'devolucao') <> 1
UNION ALL
SELECT 'devolução em pedido que não está devolvido', COUNT(*)
FROM entregas e JOIN pedidos p USING (id_pedido) WHERE e.tipo = 'devolucao' AND p.status <> 'devolvido'
UNION ALL
SELECT 'pedido com valor dos itens zero ou negativo', COUNT(*)
FROM (SELECT id_pedido FROM itens_pedido GROUP BY id_pedido
      HAVING SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) <= 0)
UNION ALL
SELECT 'linha repetida em entregas (mesmo pedido, volume, tentativa e tipo)', COUNT(*)
FROM (SELECT id_pedido, volume, tentativa, tipo FROM entregas GROUP BY ALL HAVING COUNT(*) > 1);
