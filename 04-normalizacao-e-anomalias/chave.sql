-- O que é uma linha da planilha: o par pedido + item não repete?
SELECT COUNT(*) AS linhas, COUNT(DISTINCT (id_pedido, n_item)) AS pedido_e_item_diferentes
FROM vendas_larga;
