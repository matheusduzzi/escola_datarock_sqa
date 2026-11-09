-- O ORDER BY do fim só muda a ordem em que as linhas aparecem. A janela continua a mesma.
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
       SUM(unidades) OVER (PARTITION BY dia ORDER BY hora) AS acumulado_no_dia
FROM pedidos_da_aula
ORDER BY unidades DESC, id_pedido;
