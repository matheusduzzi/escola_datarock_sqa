-- A primeira tentativa da aula: juntar clientes e pedidos e filtrar o status.
-- Mostra quantas linhas saem, quantos clientes elas têm e quantos desses clientes já devolveram um pedido.
WITH juntou AS (
    SELECT c.id_cliente, c.nome, c.cidade
    FROM clientes c
    JOIN pedidos p ON p.id_cliente = c.id_cliente
    WHERE p.status = 'entregue'
      AND p.status <> 'devolvido'
)
SELECT COUNT(*)                   AS linhas,
       COUNT(DISTINCT id_cliente) AS clientes,
       COUNT(DISTINCT id_cliente) FILTER (
           WHERE id_cliente IN (SELECT id_cliente FROM pedidos WHERE status = 'devolvido')
       )                          AS clientes_que_devolveram
FROM juntou;
