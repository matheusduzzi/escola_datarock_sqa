-- Pedido 1 da prática: as mesmas contas por canal, com janela.
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
       COUNT(*) OVER (PARTITION BY canal) AS pedidos_do_canal,
       SUM(unidades) OVER (PARTITION BY canal) AS unidades_do_canal
FROM pedidos_da_aula
ORDER BY canal, id_pedido;
