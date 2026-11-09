-- Dois clientes na primeira tentativa: quantas vezes cada um aparece e quantos pedidos de cada status ele tem.
SELECT c.id_cliente,
       (SELECT COUNT(*) FROM pedidos p
         WHERE p.id_cliente = c.id_cliente AND p.status = 'entregue' AND p.status <> 'devolvido') AS linhas_na_tentativa,
       (SELECT COUNT(*) FROM pedidos p
         WHERE p.id_cliente = c.id_cliente AND p.status = 'entregue')                            AS entregues,
       (SELECT COUNT(*) FROM pedidos p
         WHERE p.id_cliente = c.id_cliente AND p.status = 'devolvido')                           AS devolvidos
FROM clientes c
WHERE c.id_cliente IN (47, 61)
ORDER BY c.id_cliente;
