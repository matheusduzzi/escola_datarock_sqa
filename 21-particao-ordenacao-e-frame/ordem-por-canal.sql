-- Pedido 3 da prática: soma com ORDER BY canal e sem PARTITION BY.
WITH pedidos_da_aula AS (
    SELECT p.id_pedido,
           CAST(p.data_hora_pedido AS DATE) AS dia,
           strftime(p.data_hora_pedido, '%H:%M') AS hora,
           p.canal,
           SUM(i.quantidade) AS unidades
    FROM pedidos p
    JOIN itens_pedido i USING (id_pedido)
    WHERE p.data_hora_pedido >= '2026-01-02' AND p.data_hora_pedido < '2026-01-04'
    GROUP BY 1, 2, 3, 4
)
SELECT id_pedido, canal, unidades,
       SUM(unidades) OVER (ORDER BY canal) AS soma_por_canal
FROM pedidos_da_aula
ORDER BY canal, id_pedido;
