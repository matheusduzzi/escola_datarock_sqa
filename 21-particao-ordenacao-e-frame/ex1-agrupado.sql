-- Exercício, consulta 1. Preveja a saída na folha antes de rodar.
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
SELECT canal, COUNT(*) AS pedidos, SUM(unidades) AS unidades
FROM dia_6
GROUP BY canal
ORDER BY canal;
