-- Clientes com pelo menos um pedido entregue, com EXISTS. Mostra o total de linhas e de clientes.
WITH lista AS (
    SELECT c.id_cliente, c.nome, c.cidade
    FROM clientes c
    WHERE EXISTS (
        SELECT 1
        FROM pedidos p
        WHERE p.id_cliente = c.id_cliente
          AND p.status = 'entregue'
    )
)
SELECT COUNT(*) AS linhas, COUNT(DISTINCT id_cliente) AS clientes
FROM lista;
