-- A janela do Caio com RANGE: em vez de 2 linhas antes, 2 meses antes no calendário.
-- Mesmos fatos, sem tabela de meses. Só Esporte.
WITH fatos AS (
  SELECT CAST(date_trunc('month', p.data_hora_pedido) AS DATE) AS mes,
         d.categoria,
         COUNT(DISTINCT p.id_pedido) AS pedidos
  FROM pedidos p
  JOIN itens_pedido i USING (id_pedido)
  JOIN produtos d USING (id_produto)
  GROUP BY 1, 2
)
SELECT strftime(mes, '%Y-%m') AS mes,
       pedidos,
       strftime(MIN(mes) OVER w, '%Y-%m') AS janela_de,
       COUNT(*) OVER w AS linhas_na_janela,
       SUM(pedidos) OVER w AS soma,
       ROUND(AVG(pedidos) OVER w, 2) AS media_3_meses
FROM fatos
WHERE categoria = 'Esporte'
WINDOW w AS (PARTITION BY categoria ORDER BY mes
             RANGE BETWEEN INTERVAL 2 MONTH PRECEDING AND CURRENT ROW)
ORDER BY mes;
