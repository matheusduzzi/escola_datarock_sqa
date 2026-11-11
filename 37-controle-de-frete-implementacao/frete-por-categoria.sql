-- Métrica 6: o frete dos pedidos de maio dividido entre as categorias pelo valor do item.
-- Rodar depois das etapas: python3 projeto.py etapas.sql frete-por-categoria.sql
SELECT categoria,
       ROUND(venda, 2)          AS venda,
       ROUND(frete, 2)          AS frete,
       ROUND(pct_da_venda, 1)   AS pct_da_venda
FROM frete_por_categoria
WHERE mes = DATE '2026-05-01'
ORDER BY categoria;
