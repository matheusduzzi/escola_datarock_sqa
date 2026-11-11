-- O relatório depois da revisão: a consulta do Caio com uma mudança só, o filtro de maio por faixa.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
WITH por_pedido AS (
    SELECT id_pedido, canal, SUM(valor) AS valor_pedido
    FROM hist.itens_historico
    WHERE data_hora_pedido >= TIMESTAMP '2026-05-01 00:00:00'
      AND data_hora_pedido <  TIMESTAMP '2026-06-01 00:00:00'
    GROUP BY id_pedido, canal
)
SELECT canal,
       COUNT(*) AS pedidos,
       SUM(valor_pedido) AS vendido,
       ROUND(AVG(valor_pedido), 2) AS ticket_medio
FROM por_pedido
GROUP BY canal
ORDER BY canal;
