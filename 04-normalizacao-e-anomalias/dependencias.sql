-- Teste de cada dependência: para cada valor da coluna da esquerda,
-- quantos valores diferentes aparecem na coluna da direita.
-- quebras = quantos valores da esquerda têm mais de um valor na direita. Zero quer dizer que nada quebrou nos dados.
SELECT 'id_cliente -> cidade' AS dependencia, COUNT(*) FILTER (WHERE n > 1) AS quebras
FROM (SELECT id_cliente, COUNT(DISTINCT cidade) AS n FROM vendas_larga GROUP BY id_cliente)
UNION ALL
SELECT 'id_cliente -> uf', COUNT(*) FILTER (WHERE n > 1)
FROM (SELECT id_cliente, COUNT(DISTINCT uf) AS n FROM vendas_larga GROUP BY id_cliente)
UNION ALL
SELECT 'id_produto -> categoria', COUNT(*) FILTER (WHERE n > 1)
FROM (SELECT id_produto, COUNT(DISTINCT categoria) AS n FROM vendas_larga GROUP BY id_produto)
UNION ALL
SELECT 'id_produto -> preco_lista', COUNT(*) FILTER (WHERE n > 1)
FROM (SELECT id_produto, COUNT(DISTINCT preco_lista) AS n FROM vendas_larga GROUP BY id_produto)
UNION ALL
SELECT 'id_pedido -> status', COUNT(*) FILTER (WHERE n > 1)
FROM (SELECT id_pedido, COUNT(DISTINCT status) AS n FROM vendas_larga GROUP BY id_pedido)
UNION ALL
SELECT 'id_pedido -> id_cliente', COUNT(*) FILTER (WHERE n > 1)
FROM (SELECT id_pedido, COUNT(DISTINCT id_cliente) AS n FROM vendas_larga GROUP BY id_pedido)
UNION ALL
SELECT 'cidade -> uf', COUNT(*) FILTER (WHERE n > 1)
FROM (SELECT cidade, COUNT(DISTINCT uf) AS n FROM vendas_larga GROUP BY cidade);
