-- O cliente 46: o selo de cada mês, o selo de hoje e quanto ele pediu no mês.
CREATE VIEW selo_cliente AS SELECT * FROM read_csv('dados/selo_cliente.csv', header = true);

WITH valor_pedido AS (
    SELECT id_pedido, SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS valor
    FROM itens_pedido
    GROUP BY id_pedido
)
SELECT s.valido_de AS mes,
       s.selo AS selo_do_mes,
       (SELECT selo FROM selo_cliente
         WHERE id_cliente = 46 AND valido_de <= DATE '2026-06-20' AND DATE '2026-06-20' < valido_ate) AS selo_de_hoje,
       COUNT(p.id_pedido) AS pedidos,
       COALESCE(ROUND(SUM(v.valor), 2), 0) AS pedido_no_mes
FROM selo_cliente s
LEFT JOIN pedidos p
  ON p.id_cliente = s.id_cliente
 AND s.valido_de <= CAST(p.data_hora_pedido AS DATE)
 AND CAST(p.data_hora_pedido AS DATE) < s.valido_ate
LEFT JOIN valor_pedido v USING (id_pedido)
WHERE s.id_cliente = 46
GROUP BY s.valido_de, s.selo
ORDER BY s.valido_de;
