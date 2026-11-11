-- Outra reescrita: sem a etapa por pedido, contando os pedidos com COUNT(DISTINCT). Filtro por faixa.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT canal,
       COUNT(DISTINCT id_pedido) AS pedidos,
       SUM(valor) AS vendido,
       ROUND(SUM(valor) / COUNT(DISTINCT id_pedido), 2) AS ticket_medio
FROM hist.itens_historico
WHERE data_hora_pedido >= TIMESTAMP '2026-05-01 00:00:00'
  AND data_hora_pedido <  TIMESTAMP '2026-06-01 00:00:00'
GROUP BY canal
ORDER BY canal;
