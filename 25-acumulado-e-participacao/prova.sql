-- A prova, na consulta certa e na primeira tentativa (sem PARTITION BY no acumulado,
-- total do semestre no denominador). Os totais de comparação saem de consultas sem janela.
WITH vendas AS (
    SELECT strftime(p.data_hora_pedido, '%Y-%m') AS mes,
           d.categoria,
           SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor
    FROM pedidos p
    JOIN itens_pedido i USING (id_pedido)
    JOIN produtos d USING (id_produto)
    WHERE p.status <> 'cancelado'
    GROUP BY 1, 2
),
janela AS (
    SELECT mes, categoria, valor,
           ROW_NUMBER() OVER (PARTITION BY categoria ORDER BY mes DESC) AS de_tras_pra_frente,
           SUM(valor) OVER (PARTITION BY categoria ORDER BY mes) AS acum_certo,
           SUM(valor) OVER (ORDER BY mes) AS acum_primeira,
           100 * valor / SUM(valor) OVER (PARTITION BY mes) AS pct_certo,
           100 * valor / SUM(valor) OVER () AS pct_primeira
    FROM vendas
),
total_semestre AS (
    SELECT SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS total
    FROM pedidos p
    JOIN itens_pedido i USING (id_pedido)
    WHERE p.status <> 'cancelado'
),
total_por_categoria AS (
    SELECT d.categoria,
           SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS total
    FROM pedidos p
    JOIN itens_pedido i USING (id_pedido)
    JOIN produtos d USING (id_produto)
    WHERE p.status <> 'cancelado'
    GROUP BY 1
),
ultimos AS (
    SELECT j.*, t.total FROM janela j JOIN total_por_categoria t USING (categoria)
    WHERE j.de_tras_pra_frente = 1
),
por_mes AS (
    SELECT mes, SUM(pct_certo) AS soma_certo, SUM(pct_primeira) AS soma_primeira
    FROM janela
    GROUP BY mes
)
SELECT 'categorias com acumulado final = total' AS checagem,
       COUNT(*)::VARCHAR AS esperado,
       COUNT(*) FILTER (WHERE ABS(acum_certo - total) < 0.005)::VARCHAR AS certa,
       COUNT(*) FILTER (WHERE ABS(acum_primeira - total) < 0.005)::VARCHAR AS primeira
FROM ultimos
UNION ALL
SELECT 'soma dos acumulados finais',
       (SELECT ROUND(total, 2) FROM total_semestre)::VARCHAR,
       ROUND(SUM(acum_certo), 2)::VARCHAR,
       ROUND(SUM(acum_primeira), 2)::VARCHAR
FROM ultimos
UNION ALL
SELECT 'meses com participacao somando 100%',
       COUNT(*)::VARCHAR,
       COUNT(*) FILTER (WHERE ABS(soma_certo - 100) < 0.000001)::VARCHAR,
       COUNT(*) FILTER (WHERE ABS(soma_primeira - 100) < 0.000001)::VARCHAR
FROM por_mes;
