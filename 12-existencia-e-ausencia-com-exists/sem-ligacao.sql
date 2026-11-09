-- EXISTS sem a ligação com o cliente de fora: a subconsulta responde a mesma coisa para todo mundo.
SELECT COUNT(*) AS linhas
FROM clientes c
WHERE EXISTS (
    SELECT 1
    FROM pedidos p
    WHERE p.status = 'entregue'
);
