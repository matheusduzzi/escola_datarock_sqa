-- Janela: cada pedido continua na sua linha, com o total do dia ao lado.
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
SELECT id_pedido, dia, hora, unidades,
       SUM(unidades) OVER (PARTITION BY dia) AS unidades_do_dia,
       COUNT(*) OVER (PARTITION BY dia) AS pedidos_do_dia
FROM pedidos_da_aula
ORDER BY dia, hora;
