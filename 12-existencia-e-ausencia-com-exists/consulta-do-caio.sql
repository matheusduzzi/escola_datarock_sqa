-- A consulta que o Caio mandou para a pesquisa da Marta.
CREATE VIEW respostas AS
SELECT * FROM read_csv('dados/respostas_pesquisa.csv', header = true);

SELECT c.id_cliente, c.nome, c.cidade
FROM clientes c
JOIN pedidos p  ON p.id_cliente = c.id_cliente
JOIN entregas e ON e.id_pedido = p.id_pedido
WHERE e.tentativa >= 2
  AND c.id_cliente NOT IN (SELECT id_cliente FROM respostas)
ORDER BY c.id_cliente;
