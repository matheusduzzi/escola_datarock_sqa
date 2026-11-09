-- Quantos pedidos têm itens de mais de uma categoria.
WITH por_pedido AS (
  SELECT i.id_pedido, COUNT(DISTINCT d.categoria) AS categorias
  FROM itens_pedido i
  JOIN produtos d ON d.id_produto = i.id_produto
  GROUP BY i.id_pedido
)
SELECT COUNT(*)                                       AS pedidos,
       SUM(CASE WHEN categorias > 1 THEN 1 ELSE 0 END) AS com_mais_de_uma_categoria,
       MAX(categorias)                                AS maximo_de_categorias
FROM por_pedido;
