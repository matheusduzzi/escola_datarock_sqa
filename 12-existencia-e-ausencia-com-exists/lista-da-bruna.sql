-- A lista que vai para a Bruna: recebeu pelo menos um pedido, nunca devolveu e não pediu para sair.
-- Uma linha por cliente.
CREATE VIEW descadastros AS
SELECT * FROM read_csv('dados/descadastros.csv', header = true);

SELECT c.id_cliente, c.nome, c.cidade
FROM clientes c
WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.id_cliente = c.id_cliente AND p.status = 'entregue')
  AND NOT EXISTS (SELECT 1 FROM pedidos p WHERE p.id_cliente = c.id_cliente AND p.status = 'devolvido')
  AND NOT EXISTS (SELECT 1 FROM descadastros d WHERE d.id_cliente = c.id_cliente)
ORDER BY c.id_cliente;
