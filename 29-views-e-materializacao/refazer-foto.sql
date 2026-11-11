-- O que acontece se uma rotina recriar a foto de maio depois da devolução.
-- Rode depois do devolucao.sql.
ATTACH 'loja.duckdb' AS loja;

CREATE OR REPLACE TABLE loja.fechamento_maio AS
SELECT (SELECT MAX(data_hora_pedido) FROM loja.pedidos) AS base_ate,
       COUNT(*) AS pedidos,
       ROUND(SUM(valor), 2) AS vendido
FROM loja.valor_pedido
WHERE status = 'entregue'
  AND data_hora_pedido >= DATE '2026-05-01'
  AND data_hora_pedido <  DATE '2026-06-01';

SELECT 'view valor_pedido' AS de_onde, COUNT(*) AS pedidos, ROUND(SUM(valor), 2) AS vendido_maio
FROM loja.valor_pedido
WHERE status = 'entregue' AND data_hora_pedido >= DATE '2026-05-01' AND data_hora_pedido < DATE '2026-06-01'
UNION ALL
SELECT 'tabela fechamento_maio', pedidos, vendido
FROM loja.fechamento_maio;
