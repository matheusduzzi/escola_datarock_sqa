-- O cliente do pedido 733, entregue em maio, devolveu a compra.
-- O sistema muda o status. Depois, a mesma pergunta para a view e para a foto.
-- Rode o montar.sql antes: sem o arquivo loja.duckdb, a tabela loja.pedidos não existe.
ATTACH 'loja.duckdb' AS loja;

UPDATE loja.pedidos SET status = 'devolvido' WHERE id_pedido = 733;

SELECT 'view valor_pedido' AS de_onde, COUNT(*) AS pedidos, ROUND(SUM(valor), 2) AS vendido_maio
FROM loja.valor_pedido
WHERE status = 'entregue' AND data_hora_pedido >= DATE '2026-05-01' AND data_hora_pedido < DATE '2026-06-01'
UNION ALL
SELECT 'tabela fechamento_maio', pedidos, vendido
FROM loja.fechamento_maio;
