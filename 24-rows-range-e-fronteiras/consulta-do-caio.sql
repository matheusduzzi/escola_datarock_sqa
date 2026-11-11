-- A consulta do Caio para a Sônia: unidades dos 3 dias anteriores, sem contar o dia.
-- Mostra os pedidos de 16 e de 21 de janeiro.
WITH por_pedido AS (
    SELECT p.id_pedido, CAST(p.data_hora_pedido AS DATE) AS dia, SUM(i.quantidade) AS unidades
    FROM pedidos p
    JOIN itens_pedido i USING (id_pedido)
    WHERE p.status <> 'cancelado'
    GROUP BY 1, 2
),
janela AS (
    SELECT id_pedido, dia, unidades,
           SUM(unidades) OVER (ORDER BY dia, id_pedido
                               ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) AS unidades_3_dias_antes
    FROM por_pedido
)
SELECT id_pedido, dia, unidades, unidades_3_dias_antes
FROM janela
WHERE dia IN (DATE '2026-01-16', DATE '2026-01-21')
ORDER BY dia, id_pedido;
