-- O frete dos pedidos de maio dividido entre as categorias, por três regras de rateio.
-- Cada pedido tem o seu frete total; a regra diz que parte dele vai para cada item.
WITH pedidos_de_maio AS (
    SELECT id_pedido
    FROM pedidos
    WHERE data_hora_pedido >= TIMESTAMP '2026-05-01 00:00:00'
      AND data_hora_pedido <  TIMESTAMP '2026-06-01 00:00:00'
      AND status <> 'cancelado'
),
frete_do_pedido AS (
    SELECT id_pedido, SUM(custo_frete) AS frete
    FROM entregas
    WHERE id_pedido IN (SELECT id_pedido FROM pedidos_de_maio)
    GROUP BY id_pedido
),
itens AS (
    SELECT i.id_pedido, i.n_item, d.categoria, i.quantidade,
           i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0) AS valor
    FROM itens_pedido i
    JOIN produtos d USING (id_produto)
    WHERE i.id_pedido IN (SELECT id_pedido FROM pedidos_de_maio)
),
rateio AS (
    SELECT i.*, f.frete,
           f.frete * i.valor / SUM(i.valor) OVER (PARTITION BY i.id_pedido) AS pelo_valor,
           f.frete * i.quantidade / SUM(i.quantidade) OVER (PARTITION BY i.id_pedido) AS pela_quantidade,
           f.frete / COUNT(*) OVER (PARTITION BY i.id_pedido) AS por_item
    FROM itens i
    JOIN frete_do_pedido f USING (id_pedido)
),
linhas AS (
    SELECT 1 AS ordem, categoria,
           SUM(valor) AS vendas, SUM(pelo_valor) AS pelo_valor, SUM(pela_quantidade) AS pela_quantidade,
           SUM(por_item) AS por_item,
           100 * SUM(pelo_valor) / SUM(valor) AS pct_venda_valor,
           100 * SUM(pela_quantidade) / SUM(valor) AS pct_venda_quantidade
    FROM rateio
    GROUP BY categoria
    UNION ALL
    SELECT 2, 'total das categorias', SUM(valor), SUM(pelo_valor), SUM(pela_quantidade), SUM(por_item), NULL, NULL
    FROM rateio
    UNION ALL
    SELECT 3, 'frete dos pedidos', NULL, SUM(frete), SUM(frete), SUM(frete), NULL, NULL
    FROM frete_do_pedido
)
SELECT categoria, ROUND(vendas, 2) AS vendas, ROUND(pelo_valor, 2) AS pelo_valor,
       ROUND(pela_quantidade, 2) AS pela_quantidade, ROUND(por_item, 2) AS por_item,
       ROUND(pct_venda_valor, 1) AS pct_venda_valor, ROUND(pct_venda_quantidade, 1) AS pct_venda_quantidade
FROM linhas
ORDER BY ordem, categoria;
