-- A lista da Bruna com a data do último pedido entregue de cada cliente.
-- A data vem da tabela de pedidos, então aqui entra um JOIN. Os pedidos viram uma linha por cliente antes.
CREATE VIEW descadastros AS
SELECT * FROM read_csv('dados/descadastros.csv', header = true);

WITH ultimo AS (
    SELECT id_cliente, CAST(MAX(data_hora_pedido) AS DATE) AS ultimo_pedido
    FROM pedidos
    WHERE status = 'entregue'
    GROUP BY id_cliente
), lista AS (
    SELECT c.id_cliente, c.nome, c.cidade, u.ultimo_pedido
    FROM clientes c
    JOIN ultimo u ON u.id_cliente = c.id_cliente
    WHERE NOT EXISTS (SELECT 1 FROM pedidos p WHERE p.id_cliente = c.id_cliente AND p.status = 'devolvido')
      AND NOT EXISTS (SELECT 1 FROM descadastros d WHERE d.id_cliente = c.id_cliente)
)
SELECT COUNT(*) AS linhas, COUNT(DISTINCT id_cliente) AS clientes,
       MIN(ultimo_pedido) AS mais_antigo, MAX(ultimo_pedido) AS mais_recente
FROM lista;
