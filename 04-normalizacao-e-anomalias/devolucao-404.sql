-- O que a tabela de entregas da base diz sobre o pedido 404.
SELECT id_pedido, tipo, volume, tentativa, resultado
FROM read_csv_auto('../dados/entregas.csv', header = true)
WHERE id_pedido = 404
ORDER BY tipo DESC, volume, tentativa;
