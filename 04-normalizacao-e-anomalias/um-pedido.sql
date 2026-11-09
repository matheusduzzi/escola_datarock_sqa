-- As linhas de um pedido na planilha. Vem com o pedido 404; troque o número para ver outro.
SELECT id_pedido, n_item, status, produto, categoria, cidade
FROM vendas_larga
WHERE id_pedido = 404
ORDER BY n_item;
