-- Os clientes da lista sem quem pediu para sair, com NOT IN.
CREATE VIEW descadastros AS
SELECT * FROM read_csv('dados/descadastros.csv', header = true);

SELECT c.id_cliente, c.nome, c.cidade
FROM clientes c
WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.id_cliente = c.id_cliente AND p.status = 'entregue')
  AND NOT EXISTS (SELECT 1 FROM pedidos p WHERE p.id_cliente = c.id_cliente AND p.status = 'devolvido')
  AND c.id_cliente NOT IN (SELECT id_cliente FROM descadastros)
ORDER BY c.id_cliente;
