-- Monta o arquivo loja.duckdb, nesta pasta, com:
--   uma cópia de pedidos e itens, que faz o papel do sistema da loja;
--   a view valor_pedido, que lê a cópia toda vez;
--   a tabela fechamento_maio, a foto que a Marta mandou ao financeiro.
-- Rodar de novo apaga o que mudou e volta tudo ao começo.
ATTACH 'loja.duckdb' AS loja;

CREATE OR REPLACE TABLE loja.pedidos AS FROM pedidos;
CREATE OR REPLACE TABLE loja.itens_pedido AS FROM itens_pedido;

CREATE OR REPLACE VIEW loja.valor_pedido AS
SELECT p.id_pedido, p.data_hora_pedido, p.status,
       SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor
FROM loja.pedidos p
JOIN loja.itens_pedido i ON i.id_pedido = p.id_pedido
GROUP BY p.id_pedido, p.data_hora_pedido, p.status;

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
