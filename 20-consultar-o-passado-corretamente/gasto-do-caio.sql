-- A primeira versão do Caio: quanto um cliente de cada selo pede por mês, de fevereiro a maio de 2026.
-- O selo vem da linha que vale hoje (20/06/2026). É a versão com o erro da aula.
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
),
meses AS (
    SELECT CAST(m AS DATE) AS mes FROM range(DATE '2026-02-01', DATE '2026-06-01', INTERVAL 1 MONTH) t(m)
),
cliente_mes AS (
    SELECT h.id_cliente, h.selo, m.mes,
           COALESCE((SELECT SUM(v.valor)
                     FROM pedidos p JOIN valor_pedido v USING (id_pedido)
                     WHERE p.id_cliente = h.id_cliente
                       AND p.data_hora_pedido >= m.mes
                       AND p.data_hora_pedido <  m.mes + INTERVAL 1 MONTH), 0) AS pedido_no_mes
    FROM selo_de_hoje h CROSS JOIN meses m
)
SELECT selo, COUNT(*) AS clientes_mes, ROUND(AVG(pedido_no_mes), 2) AS media_por_mes
FROM cliente_mes
GROUP BY selo
ORDER BY media_por_mes DESC;
