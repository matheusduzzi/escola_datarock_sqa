-- Duas contas de cobertura para Esporte, mês a mês:
-- os dias que a base cobre (calendário de dias) e os dias em que houve pedido de Esporte.
WITH limites AS (
  SELECT CAST(MIN(data_hora_pedido) AS DATE) AS primeiro_dia,
         CAST(MAX(data_hora_pedido) AS DATE) AS ultimo_dia
  FROM pedidos
),
dias AS (
  SELECT CAST(t.dia AS DATE) AS dia
  FROM limites, range(limites.primeiro_dia, limites.ultimo_dia + 1, INTERVAL 1 DAY) AS t(dia)
),
dias_esporte AS (
  SELECT DISTINCT CAST(p.data_hora_pedido AS DATE) AS dia
  FROM pedidos p
  JOIN itens_pedido i USING (id_pedido)
  JOIN produtos d USING (id_produto)
  WHERE d.categoria = 'Esporte'
)
SELECT strftime(date_trunc('month', c.dia), '%Y-%m') AS mes,
       day(last_day(MIN(c.dia))) AS dias_no_mes,
       COUNT(*) AS dias_na_base,
       COUNT(e.dia) AS dias_com_esporte
FROM dias c
LEFT JOIN dias_esporte e ON e.dia = c.dia
GROUP BY 1
ORDER BY 1;
