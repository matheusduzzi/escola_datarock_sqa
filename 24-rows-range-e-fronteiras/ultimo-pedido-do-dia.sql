-- O último pedido de cada dia com LAST_VALUE: com o frame padrão e com o frame até o fim do dia.
-- Mostra os pedidos de 2 de janeiro.
WITH p AS (
    SELECT id_pedido, CAST(data_hora_pedido AS DATE) AS dia, data_hora_pedido
    FROM pedidos
    WHERE status <> 'cancelado'
)
SELECT id_pedido,
       strftime(data_hora_pedido, '%H:%M') AS hora,
       LAST_VALUE(id_pedido) OVER (PARTITION BY dia ORDER BY data_hora_pedido) AS com_frame_padrao,
       LAST_VALUE(id_pedido) OVER (PARTITION BY dia ORDER BY data_hora_pedido
                                   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ate_o_fim_do_dia
FROM p
WHERE dia = DATE '2026-01-02'
ORDER BY data_hora_pedido;
