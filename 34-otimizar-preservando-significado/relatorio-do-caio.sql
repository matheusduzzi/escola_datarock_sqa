-- O relatório da Lúcia como o Caio escreveu: pedidos, vendido e ticket médio de maio de 2026, por canal.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
WITH por_pedido AS (
    SELECT id_pedido, canal, SUM(valor) AS valor_pedido
    FROM hist.itens_historico
    WHERE strftime(data_hora_pedido, '%Y-%m') = '2026-05'
    GROUP BY id_pedido, canal
)
SELECT canal,
       COUNT(*) AS pedidos,
       SUM(valor_pedido) AS vendido,
       ROUND(AVG(valor_pedido), 2) AS ticket_medio
FROM por_pedido
GROUP BY canal
ORDER BY canal;
