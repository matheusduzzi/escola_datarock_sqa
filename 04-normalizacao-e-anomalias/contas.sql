-- A planilha do Renato: três contas que deveriam bater.
-- Soma dos clientes de cada cidade contra os clientes diferentes da planilha,
-- e soma dos pedidos de cada status contra os pedidos diferentes.
SELECT 'clientes' AS conta,
       (SELECT SUM(n) FROM (SELECT cidade, COUNT(DISTINCT id_cliente) AS n FROM vendas_larga GROUP BY cidade)) AS somando_os_grupos,
       (SELECT COUNT(DISTINCT id_cliente) FROM vendas_larga) AS na_planilha
UNION ALL
SELECT 'pedidos',
       (SELECT SUM(n) FROM (SELECT status, COUNT(DISTINCT id_pedido) AS n FROM vendas_larga GROUP BY status)),
       (SELECT COUNT(DISTINCT id_pedido) FROM vendas_larga)
UNION ALL
SELECT 'produtos',
       (SELECT SUM(n) FROM (SELECT categoria, COUNT(DISTINCT id_produto) AS n FROM vendas_larga GROUP BY categoria)),
       (SELECT COUNT(DISTINCT id_produto) FROM vendas_larga);
