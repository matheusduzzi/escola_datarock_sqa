-- Quantos itens foram vendidos por um preço diferente do preço de tabela de hoje.
SELECT COUNT(*)                                                     AS itens,
       SUM(CASE WHEN i.preco_unitario <> d.preco_lista THEN 1 ELSE 0 END) AS preco_diferente_da_tabela
FROM itens_pedido i
JOIN produtos d ON d.id_produto = i.id_produto;
