-- A consulta "valor por pedido" escrita uma vez só, como view.
-- Os três relatórios leem a view em vez de ter uma cópia cada um.
CREATE VIEW valor_pedido AS
SELECT p.id_pedido, p.data_hora_pedido, p.status, p.canal,
       COUNT(*) AS itens,
       SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor
FROM pedidos p
JOIN itens_pedido i ON i.id_pedido = p.id_pedido
GROUP BY p.id_pedido, p.data_hora_pedido, p.status, p.canal;

SELECT 'painel da Lúcia' AS relatorio, 'vendido em maio' AS o_que, ROUND(SUM(valor), 2) AS valor
FROM valor_pedido
WHERE status = 'entregue' AND data_hora_pedido >= DATE '2026-05-01' AND data_hora_pedido < DATE '2026-06-01'
UNION ALL
SELECT 'fechamento da Marta', 'vendido em maio', ROUND(SUM(valor), 2)
FROM valor_pedido
WHERE status = 'entregue' AND data_hora_pedido >= DATE '2026-05-01' AND data_hora_pedido < DATE '2026-06-01'
UNION ALL
SELECT 'tela do atendimento', 'pedido 733', valor
FROM valor_pedido
WHERE id_pedido = 733;
