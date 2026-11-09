-- Quantas vezes cada fato aparece escrito na planilha.
-- linhas: em quantas linhas o fato está; donos: quantos clientes, produtos ou pedidos diferentes;
-- copias_a_mais: linhas - donos, as vezes em que o mesmo fato foi escrito de novo.
SELECT 'cidade do cliente' AS fato, COUNT(*) AS linhas, COUNT(DISTINCT id_cliente) AS donos,
       COUNT(*) - COUNT(DISTINCT id_cliente) AS copias_a_mais
FROM vendas_larga
UNION ALL
SELECT 'categoria do produto', COUNT(*), COUNT(DISTINCT id_produto), COUNT(*) - COUNT(DISTINCT id_produto)
FROM vendas_larga
UNION ALL
SELECT 'status do pedido', COUNT(*), COUNT(DISTINCT id_pedido), COUNT(*) - COUNT(DISTINCT id_pedido)
FROM vendas_larga;
