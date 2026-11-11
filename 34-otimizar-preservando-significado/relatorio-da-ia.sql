-- A versão que a IA mandou quando o Caio pediu "deixe essa consulta mais rápida".
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT canal,
       approx_count_distinct(id_pedido) AS pedidos,
       SUM(valor) AS vendido,
       ROUND(SUM(valor) / approx_count_distinct(id_pedido), 2) AS ticket_medio
FROM hist.itens_historico
WHERE data_hora_pedido BETWEEN '2026-05-01' AND '2026-05-31'
GROUP BY canal;
