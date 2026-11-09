-- Quanto um cliente de cada selo pede por mês, de fevereiro a maio de 2026,
-- com o selo que valia no mês: cada linha do histórico junta os pedidos dos dias em que ela valeu.
CREATE VIEW selo_cliente AS SELECT * FROM read_csv('dados/selo_cliente.csv', header = true);

WITH valor_pedido AS (
    SELECT id_pedido, SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS valor
    FROM itens_pedido
    GROUP BY id_pedido
),
pedido_dia AS (
    SELECT p.id_pedido, p.id_cliente, CAST(p.data_hora_pedido AS DATE) AS dia, v.valor
    FROM pedidos p JOIN valor_pedido v USING (id_pedido)
),
cliente_mes AS (
    SELECT s.id_cliente, s.selo, s.valido_de AS mes, COALESCE(SUM(d.valor), 0) AS pedido_no_mes
    FROM selo_cliente s
    LEFT JOIN pedido_dia d
      ON d.id_cliente = s.id_cliente
     AND s.valido_de <= d.dia
     AND d.dia < s.valido_ate
    WHERE s.valido_de >= DATE '2026-02-01' AND s.valido_de < DATE '2026-06-01'
    GROUP BY s.id_cliente, s.selo, s.valido_de
)
SELECT selo, COUNT(*) AS clientes_mes, ROUND(AVG(pedido_no_mes), 2) AS media_por_mes
FROM cliente_mes
GROUP BY selo
ORDER BY media_por_mes DESC;
