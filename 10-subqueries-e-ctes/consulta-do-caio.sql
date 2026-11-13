-- A primeira resposta do Caio: quem tem mais de um pedido em março.
SELECT COUNT(*)                            AS clientes_marco,
       COUNT(*) FILTER (WHERE pedidos > 1) AS voltaram
FROM (
    SELECT id_cliente,
           COUNT(*) AS pedidos
    FROM pedidos
    WHERE data_hora_pedido >= TIMESTAMP '2026-03-01'
      AND data_hora_pedido <  TIMESTAMP '2026-04-01'
    GROUP BY id_cliente
) AS marco;
