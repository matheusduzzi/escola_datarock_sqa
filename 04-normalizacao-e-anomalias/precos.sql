-- O preço de lista e o preço que o cliente pagou são o mesmo fato?
SELECT COUNT(*) AS linhas,
       COUNT(*) FILTER (WHERE preco_unitario <> preco_lista) AS pago_diferente_da_lista,
       COUNT(DISTINCT id_produto) AS produtos,
       (SELECT COUNT(*) FROM (SELECT id_produto FROM vendas_larga GROUP BY id_produto
                              HAVING COUNT(DISTINCT preco_unitario) > 1)) AS produtos_com_mais_de_um_preco_pago
FROM vendas_larga;
