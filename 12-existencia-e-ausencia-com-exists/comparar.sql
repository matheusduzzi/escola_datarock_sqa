-- As duas listas, a do EXISTS e a do JOIN, são os mesmos clientes?
-- EXCEPT tira da primeira lista o que está na segunda. Zero nos dois sentidos: as listas são iguais.
WITH pelo_exists AS (
    SELECT c.id_cliente FROM clientes c
    WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.id_cliente = c.id_cliente AND p.status = 'entregue')
      AND NOT EXISTS (SELECT 1 FROM pedidos p WHERE p.id_cliente = c.id_cliente AND p.status = 'devolvido')
), pelo_join AS (
    SELECT c.id_cliente FROM clientes c
    JOIN (SELECT DISTINCT id_cliente FROM pedidos WHERE status = 'entregue') e ON e.id_cliente = c.id_cliente
    LEFT JOIN (SELECT DISTINCT id_cliente FROM pedidos WHERE status = 'devolvido') d ON d.id_cliente = c.id_cliente
    WHERE d.id_cliente IS NULL
)
SELECT (SELECT COUNT(*) FROM pelo_exists)                                          AS no_exists,
       (SELECT COUNT(*) FROM pelo_join)                                            AS no_join,
       (SELECT COUNT(*) FROM (SELECT * FROM pelo_exists EXCEPT SELECT * FROM pelo_join)) AS so_no_exists,
       (SELECT COUNT(*) FROM (SELECT * FROM pelo_join EXCEPT SELECT * FROM pelo_exists)) AS so_no_join;
