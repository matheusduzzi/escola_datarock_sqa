-- Quantos clientes da lista de 70 pediram para sair? Com IN e com JOIN na lista de descadastro.
CREATE VIEW descadastros AS
SELECT * FROM read_csv('dados/descadastros.csv', header = true);

WITH elegiveis AS (
    SELECT c.id_cliente FROM clientes c
    WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.id_cliente = c.id_cliente AND p.status = 'entregue')
      AND NOT EXISTS (SELECT 1 FROM pedidos p WHERE p.id_cliente = c.id_cliente AND p.status = 'devolvido')
)
SELECT (SELECT COUNT(*) FROM elegiveis e
         WHERE e.id_cliente IN (SELECT id_cliente FROM descadastros)) AS com_in,
       (SELECT COUNT(*) FROM elegiveis e
         JOIN descadastros d ON d.id_cliente = e.id_cliente)          AS com_join;
