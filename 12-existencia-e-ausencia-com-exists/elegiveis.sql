-- Receberam pelo menos um pedido (EXISTS) e nunca devolveram nenhum (NOT EXISTS).
WITH lista AS (
    SELECT c.id_cliente, c.nome, c.cidade
    FROM clientes c
    WHERE EXISTS (
        SELECT 1 FROM pedidos p
        WHERE p.id_cliente = c.id_cliente AND p.status = 'entregue'
    )
      AND NOT EXISTS (
        SELECT 1 FROM pedidos p
        WHERE p.id_cliente = c.id_cliente AND p.status = 'devolvido'
    )
)
SELECT COUNT(*) AS linhas, COUNT(DISTINCT id_cliente) AS clientes
FROM lista;
