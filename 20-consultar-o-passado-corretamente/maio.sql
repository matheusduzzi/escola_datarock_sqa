-- Só maio de 2026: o selo de hoje (gravado em 01/06 com os pedidos de maio) contra o selo que valia em maio.
CREATE VIEW selo_cliente AS SELECT * FROM read_csv('dados/selo_cliente.csv', header = true);

WITH valor_pedido AS (
    SELECT id_pedido, SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS valor
    FROM itens_pedido
    GROUP BY id_pedido
),
maio AS (
    SELECT p.id_cliente, SUM(v.valor) AS pedido_em_maio
    FROM pedidos p JOIN valor_pedido v USING (id_pedido)
    WHERE p.data_hora_pedido >= TIMESTAMP '2026-05-01' AND p.data_hora_pedido < TIMESTAMP '2026-06-01'
    GROUP BY p.id_cliente
),
selos AS (
    SELECT id_cliente,
           MAX(selo) FILTER (WHERE valido_de = DATE '2026-05-01') AS selo_de_maio,
           MAX(selo) FILTER (WHERE valido_de = DATE '2026-06-01') AS selo_de_hoje
    FROM selo_cliente
    GROUP BY id_cliente
)
SELECT 'selo de hoje' AS jeito, selo_de_hoje AS selo, COUNT(*) AS clientes,
       ROUND(AVG(COALESCE(m.pedido_em_maio, 0)), 2) AS media_em_maio
FROM selos s LEFT JOIN maio m USING (id_cliente)
WHERE selo_de_maio IS NOT NULL
GROUP BY selo_de_hoje
UNION ALL
SELECT 'selo de maio', selo_de_maio, COUNT(*), ROUND(AVG(COALESCE(m.pedido_em_maio, 0)), 2)
FROM selos s LEFT JOIN maio m USING (id_cliente)
WHERE selo_de_maio IS NOT NULL
GROUP BY selo_de_maio
ORDER BY jeito, media_em_maio DESC;
