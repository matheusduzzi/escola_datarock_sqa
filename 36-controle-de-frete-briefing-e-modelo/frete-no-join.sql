-- O frete de maio somado depois de juntar entregas com itens, e somado antes de juntar.
-- É o pedido 3 da prática guiada.
WITH pedidos_de_maio AS (
    SELECT id_pedido
    FROM pedidos
    WHERE data_hora_pedido >= TIMESTAMP '2026-05-01 00:00:00'
      AND data_hora_pedido <  TIMESTAMP '2026-06-01 00:00:00'
      AND status <> 'cancelado'
)
SELECT 'entregas juntadas com itens, depois somadas' AS jeito,
       COUNT(*) AS linhas, ROUND(SUM(e.custo_frete), 2) AS frete
FROM entregas e
JOIN itens_pedido i USING (id_pedido)
WHERE e.id_pedido IN (SELECT id_pedido FROM pedidos_de_maio)
UNION ALL
SELECT 'só a tabela entregas', COUNT(*), ROUND(SUM(custo_frete), 2)
FROM entregas
WHERE id_pedido IN (SELECT id_pedido FROM pedidos_de_maio);
