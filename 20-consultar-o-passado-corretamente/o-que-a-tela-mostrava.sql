-- Os pedidos de 01/04 a 07/04/2026: o selo que valia no dia e o selo que o sistema já tinha gravado no dia.
-- A rodada de abril do CRM foi gravada em 08/04.
CREATE VIEW selo_cliente AS SELECT * FROM read_csv('dados/selo_cliente.csv', header = true);

WITH semana AS (
    SELECT id_pedido, id_cliente, CAST(data_hora_pedido AS DATE) AS dia
    FROM pedidos
    WHERE data_hora_pedido >= TIMESTAMP '2026-04-01' AND data_hora_pedido < TIMESTAMP '2026-04-08'
),
lado_a_lado AS (
    SELECT w.id_pedido,
           (SELECT s.selo FROM selo_cliente s
             WHERE s.id_cliente = w.id_cliente
               AND s.valido_de <= w.dia AND w.dia < s.valido_ate) AS selo_que_valia,
           (SELECT s.selo FROM selo_cliente s
             WHERE s.id_cliente = w.id_cliente
               AND s.valido_de <= w.dia AND w.dia < s.valido_ate
               AND s.registrado_em <= w.dia) AS selo_gravado_no_dia
    FROM semana w
)
SELECT COALESCE(selo_que_valia, 'sem selo') AS selo_que_valia,
       COALESCE(selo_gravado_no_dia, 'sem selo') AS selo_gravado_no_dia,
       COUNT(*) AS pedidos
FROM lado_a_lado
GROUP BY ALL
ORDER BY pedidos DESC, selo_que_valia;
