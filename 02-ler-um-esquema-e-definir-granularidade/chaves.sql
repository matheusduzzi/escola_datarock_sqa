-- Uma coluna (ou um grupo de colunas) só é chave se nenhuma combinação se repete.
-- Para cada candidata, compare o número de linhas com o número de combinações diferentes.
SELECT 'pedidos' AS tabela, 'id_pedido' AS candidata,
       (SELECT COUNT(*) FROM pedidos) AS linhas,
       (SELECT COUNT(*) FROM (SELECT DISTINCT id_pedido FROM pedidos) AS t) AS diferentes
UNION ALL
SELECT 'itens_pedido', 'id_pedido',
       (SELECT COUNT(*) FROM itens_pedido),
       (SELECT COUNT(*) FROM (SELECT DISTINCT id_pedido FROM itens_pedido) AS t)
UNION ALL
SELECT 'itens_pedido', 'id_pedido + n_item',
       (SELECT COUNT(*) FROM itens_pedido),
       (SELECT COUNT(*) FROM (SELECT DISTINCT id_pedido, n_item FROM itens_pedido) AS t)
UNION ALL
SELECT 'entregas', 'id_entrega',
       (SELECT COUNT(*) FROM entregas),
       (SELECT COUNT(*) FROM (SELECT DISTINCT id_entrega FROM entregas) AS t)
UNION ALL
SELECT 'entregas', 'id_pedido + volume + tentativa',
       (SELECT COUNT(*) FROM entregas),
       (SELECT COUNT(*) FROM (SELECT DISTINCT id_pedido, volume, tentativa FROM entregas) AS t)
UNION ALL
SELECT 'entregas', 'id_pedido + tipo + volume + tentativa',
       (SELECT COUNT(*) FROM entregas),
       (SELECT COUNT(*) FROM (SELECT DISTINCT id_pedido, tipo, volume, tentativa FROM entregas) AS t);
