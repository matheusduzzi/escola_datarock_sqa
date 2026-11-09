-- Para cada relação: quantos filhos cada pai tem (mínimo e máximo) e quantos pais ficam sem filho.
-- O LEFT JOIN mantém o pai sem filho; COUNT(coluna do filho) dá 0 para ele, COUNT(*) daria 1.
WITH
itens AS (
    SELECT p.id_pedido, COUNT(i.n_item) AS n
    FROM pedidos p LEFT JOIN itens_pedido i ON i.id_pedido = p.id_pedido
    GROUP BY p.id_pedido),
entregas_por_pedido AS (
    SELECT p.id_pedido, COUNT(e.id_entrega) AS n
    FROM pedidos p LEFT JOIN entregas e ON e.id_pedido = p.id_pedido
    GROUP BY p.id_pedido),
volumes AS (
    SELECT p.id_pedido, COUNT(DISTINCT e.volume) AS n
    FROM pedidos p LEFT JOIN entregas e ON e.id_pedido = p.id_pedido AND e.tipo = 'ida'
    GROUP BY p.id_pedido),
tentativas AS (
    SELECT id_pedido, volume, COUNT(*) AS n
    FROM entregas WHERE tipo = 'ida'
    GROUP BY id_pedido, volume)
SELECT 'pedido -> itens' AS relacao, COUNT(*) AS pais, MIN(n) AS minimo, MAX(n) AS maximo,
       COUNT(*) FILTER (WHERE n = 0) AS sem_filho FROM itens
UNION ALL
SELECT 'pedido -> entregas', COUNT(*), MIN(n), MAX(n), COUNT(*) FILTER (WHERE n = 0) FROM entregas_por_pedido
UNION ALL
SELECT 'pedido -> volumes', COUNT(*), MIN(n), MAX(n), COUNT(*) FILTER (WHERE n = 0) FROM volumes
UNION ALL
SELECT 'volume -> tentativas', COUNT(*), MIN(n), MAX(n), COUNT(*) FILTER (WHERE n = 0) FROM tentativas;
