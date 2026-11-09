-- A versão do Caio para o Renato: vendas entregues do semestre (01/01 a 20/06/2026) por UF e selo.
-- A UF vem do cadastro e o selo vem da linha que vale hoje (20/06/2026).
CREATE VIEW selo_cliente AS SELECT * FROM read_csv('dados/selo_cliente.csv', header = true);

WITH valor_pedido AS (
    SELECT id_pedido, SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS valor
    FROM itens_pedido
    GROUP BY id_pedido
),
selo_de_hoje AS (
    SELECT id_cliente, selo
    FROM selo_cliente
    WHERE valido_de <= DATE '2026-06-20' AND DATE '2026-06-20' < valido_ate
)
SELECT c.uf, h.selo, COUNT(*) AS pedidos, ROUND(SUM(v.valor), 2) AS valor
FROM pedidos p
JOIN valor_pedido v USING (id_pedido)
JOIN clientes c USING (id_cliente)
JOIN selo_de_hoje h USING (id_cliente)
WHERE p.status = 'entregue'
GROUP BY c.uf, h.selo
ORDER BY c.uf, h.selo;
