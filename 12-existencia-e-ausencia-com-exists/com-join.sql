-- A mesma pergunta só com JOIN: uma lista de clientes com entrega (sem repetir) e um LEFT JOIN
-- com os clientes que devolveram, ficando só com quem não achou par.
WITH com_entrega AS (
    SELECT DISTINCT id_cliente FROM pedidos WHERE status = 'entregue'
), com_devolucao AS (
    SELECT DISTINCT id_cliente FROM pedidos WHERE status = 'devolvido'
), lista AS (
    SELECT c.id_cliente, c.nome, c.cidade
    FROM clientes c
    JOIN com_entrega e ON e.id_cliente = c.id_cliente
    LEFT JOIN com_devolucao d ON d.id_cliente = c.id_cliente
    WHERE d.id_cliente IS NULL
)
SELECT COUNT(*) AS linhas, COUNT(DISTINCT id_cliente) AS clientes
FROM lista;
