-- As três cópias da consulta "valor por pedido", como estão nos três relatórios do Caio.
-- Cada relatório soma o vendido em maio: pedidos entregues de 01/05 a 31/05/2026.
WITH
painel AS (        -- cópia do painel da Lúcia
    SELECT p.id_pedido, p.status, p.data_hora_pedido,
           SUM(i.quantidade * i.preco_unitario - i.desconto) AS valor
    FROM pedidos p
    JOIN itens_pedido i ON i.id_pedido = p.id_pedido
    GROUP BY p.id_pedido, p.status, p.data_hora_pedido
),
fechamento AS (    -- cópia do fechamento da Marta
    SELECT p.id_pedido, p.status, p.data_hora_pedido,
           SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor
    FROM pedidos p
    JOIN itens_pedido i ON i.id_pedido = p.id_pedido
    GROUP BY p.id_pedido, p.status, p.data_hora_pedido
),
atendimento AS (   -- cópia da tela do atendimento
    SELECT p.id_pedido, p.status, p.data_hora_pedido,
           SUM(i.quantidade * i.preco_unitario) AS valor
    FROM pedidos p
    JOIN itens_pedido i ON i.id_pedido = p.id_pedido
    GROUP BY p.id_pedido, p.status, p.data_hora_pedido
),
todas AS (
    SELECT 1 AS ordem, 'painel da Lúcia' AS relatorio, * FROM painel
    UNION ALL
    SELECT 2, 'fechamento da Marta', * FROM fechamento
    UNION ALL
    SELECT 3, 'tela do atendimento', * FROM atendimento
)
SELECT relatorio,
       COUNT(*) AS pedidos,
       COUNT(valor) AS com_valor,
       ROUND(SUM(valor), 2) AS vendido_maio
FROM todas
WHERE status = 'entregue'
  AND data_hora_pedido >= DATE '2026-05-01'
  AND data_hora_pedido <  DATE '2026-06-01'
GROUP BY ordem, relatorio
ORDER BY ordem;
