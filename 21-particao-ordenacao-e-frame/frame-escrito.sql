-- O frame por extenso. A primeira coluna usa o padrão, a segunda escreve o mesmo padrão,
-- a terceira soma só o pedido anterior e o atual.
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
       SUM(unidades) OVER (PARTITION BY dia ORDER BY hora) AS padrao,
       SUM(unidades) OVER (PARTITION BY dia ORDER BY hora
                           RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS padrao_escrito,
       SUM(unidades) OVER (PARTITION BY dia ORDER BY hora
                           ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS com_o_anterior
FROM pedidos_da_aula
ORDER BY dia, hora;
