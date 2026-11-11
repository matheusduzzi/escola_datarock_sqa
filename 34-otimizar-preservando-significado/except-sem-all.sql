-- Duas listas pequenas: a segunda tem uma linha a menos. EXCEPT e EXCEPT ALL, nos dois sentidos. É o pedido 2 da prática.
WITH a AS (
    SELECT * FROM (VALUES ('app', 101, 250.00), ('app', 101, 250.00), ('loja', 102, 90.50)) AS t(canal, id_pedido, valor)
), b AS (
    SELECT * FROM (VALUES ('app', 101, 250.00), ('loja', 102, 90.50)) AS t(canal, id_pedido, valor)
)
SELECT 'linhas em a' AS conta, COUNT(*) AS n FROM a
UNION ALL SELECT 'linhas em b', COUNT(*) FROM b
UNION ALL SELECT 'a EXCEPT b', COUNT(*) FROM (SELECT * FROM a EXCEPT SELECT * FROM b)
UNION ALL SELECT 'b EXCEPT a', COUNT(*) FROM (SELECT * FROM b EXCEPT SELECT * FROM a)
UNION ALL SELECT 'a EXCEPT ALL b', COUNT(*) FROM (SELECT * FROM a EXCEPT ALL SELECT * FROM b)
UNION ALL SELECT 'b EXCEPT ALL a', COUNT(*) FROM (SELECT * FROM b EXCEPT ALL SELECT * FROM a);
