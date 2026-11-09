-- As mesmas etapas do relatorio-ia.sql. No fim, no lugar do relatório, a conferência:
-- uma linha por etapa, com quantas linhas ela tem, quantas chaves diferentes e quanto soma.
WITH vendas AS (
    SELECT p.id_pedido,
           strftime(p.data_hora_pedido, '%Y-%m') AS mes,
           SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor_pedido
    FROM pedidos p
    JOIN itens_pedido i ON i.id_pedido = p.id_pedido
    WHERE p.status IN ('entregue', 'em_andamento')
    GROUP BY p.id_pedido, mes
),
itens_categoria AS (
    SELECT v.id_pedido,
           i.n_item,
           v.mes,
           pr.categoria,
           v.valor_pedido AS valor
    FROM vendas v
    JOIN itens_pedido i ON i.id_pedido = v.id_pedido
    JOIN produtos pr    ON pr.id_produto = i.id_produto
),
por_mes_categoria AS (
    SELECT mes,
           categoria,
           SUM(valor) AS venda,
           COUNT(*)   AS pedidos
    FROM itens_categoria
    GROUP BY mes, categoria
),
conferencia AS (
    SELECT 1 AS ordem, 'vendas' AS etapa,
           COUNT(*) AS linhas,
           (SELECT COUNT(*) FROM (SELECT DISTINCT id_pedido FROM vendas)) AS chaves,
           ROUND(SUM(valor_pedido), 2) AS total
    FROM vendas
    UNION ALL
    SELECT 2, 'itens_categoria',
           COUNT(*),
           (SELECT COUNT(*) FROM (SELECT DISTINCT id_pedido, n_item FROM itens_categoria)),
           ROUND(SUM(valor), 2)
    FROM itens_categoria
    UNION ALL
    SELECT 3, 'por_mes_categoria',
           COUNT(*),
           (SELECT COUNT(*) FROM (SELECT DISTINCT mes, categoria FROM por_mes_categoria)),
           ROUND(SUM(venda), 2)
    FROM por_mes_categoria
)
SELECT etapa, linhas, chaves, total,
       ROUND(total - (SELECT total FROM conferencia WHERE ordem = 1), 2) AS diferenca
FROM conferencia
ORDER BY ordem;
