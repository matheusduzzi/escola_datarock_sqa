-- Exercício, consulta 4. Preveja a saída na folha antes de rodar.
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
SELECT id_pedido, canal, hora, unidades,
       SUM(unidades) OVER (PARTITION BY canal ORDER BY hora
                           ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS com_o_anterior
FROM dia_6
ORDER BY canal, hora, id_pedido;
