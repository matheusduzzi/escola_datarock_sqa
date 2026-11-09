-- Se o Renato apagar as linhas de janeiro, quem some da planilha junto com a cidade?
SELECT id_cliente, cidade, COUNT(*) AS linhas, MAX(data_pedido) AS ultima_compra
FROM vendas_larga
GROUP BY id_cliente, cidade
HAVING MAX(data_pedido) < DATE '2026-02-01'
ORDER BY id_cliente;
