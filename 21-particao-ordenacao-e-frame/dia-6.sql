-- Exercício: os pedidos de 6 de janeiro, uma linha por pedido. Hora em minutos.
WITH dia_6 AS (
    SELECT p.id_pedido,
           strftime(p.data_hora_pedido, '%H:%M') AS hora,
           p.canal,
           SUM(i.quantidade) AS unidades
    FROM pedidos p
    JOIN itens_pedido i USING (id_pedido)
    WHERE CAST(p.data_hora_pedido AS DATE) = DATE '2026-01-06'
    GROUP BY 1, 2, 3
)
SELECT * FROM dia_6
ORDER BY hora, id_pedido;
