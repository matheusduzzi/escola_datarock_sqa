-- O rateio do pedido 687 pelo valor dos itens: a parte de cada item sem arredondar,
-- a soma por categoria arredondada e a conta de fechamento com o frete do pedido.
WITH frete AS (
    SELECT SUM(custo_frete) AS frete FROM entregas WHERE id_pedido = 687
),
itens AS (
    SELECT i.n_item, d.nome, d.categoria,
           i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0) AS valor
    FROM itens_pedido i
    JOIN produtos d USING (id_produto)
    WHERE i.id_pedido = 687
),
rateio AS (
    SELECT itens.*, frete.frete * valor / SUM(valor) OVER () AS parte
    FROM itens, frete
),
por_categoria AS (
    SELECT categoria, SUM(parte) AS parte FROM rateio GROUP BY categoria
),
linhas AS (
    SELECT 1 AS ordem, 'item ' || n_item || ' ' || nome AS linha, categoria, valor, ROUND(parte, 4) AS parte
    FROM rateio
    UNION ALL
    SELECT 2, 'categoria', categoria, NULL, ROUND(parte, 2) FROM por_categoria
    UNION ALL
    SELECT 3, 'soma das categorias arredondadas', NULL, NULL, SUM(ROUND(parte, 2)) FROM por_categoria
    UNION ALL
    SELECT 4, 'frete do pedido', NULL, NULL, ROUND(frete, 2) FROM frete
)
SELECT linha, categoria, ROUND(valor, 2) AS valor, parte
FROM linhas
ORDER BY ordem, linha, categoria;
