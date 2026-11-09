-- O último acumulado de cada categoria contra o total da categoria calculado à parte.
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
com_acumulado AS (
    SELECT mes, categoria,
           SUM(valor) OVER (PARTITION BY categoria ORDER BY mes) AS acumulado,
           ROW_NUMBER() OVER (PARTITION BY categoria ORDER BY mes DESC) AS de_tras_pra_frente
    FROM vendas
),
ultimo AS (
    SELECT categoria, mes AS ultimo_mes, acumulado FROM com_acumulado WHERE de_tras_pra_frente = 1
),
total_direto AS (
    -- Sem janela: a soma dos itens da categoria no semestre, direto das tabelas.
    SELECT d.categoria,
           SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS total
    FROM pedidos p
    JOIN itens_pedido i USING (id_pedido)
    JOIN produtos d USING (id_produto)
    WHERE p.status <> 'cancelado'
    GROUP BY 1
)
SELECT u.categoria, u.ultimo_mes,
       ROUND(u.acumulado, 2) AS ultimo_acumulado,
       ROUND(t.total, 2) AS total_da_categoria,
       CAST(ROUND(u.acumulado - t.total, 2) AS DECIMAL(12, 2)) AS diferenca
FROM ultimo u
JOIN total_direto t USING (categoria)
ORDER BY u.categoria;
