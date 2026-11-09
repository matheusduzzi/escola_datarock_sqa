-- Pedido 1 da prática: quais meses entraram na média de junho de Esporte,
-- na consulta do Caio e na série completa.
WITH limites AS (
  SELECT CAST(MIN(data_hora_pedido) AS DATE) AS primeiro_dia,
         CAST(MAX(data_hora_pedido) AS DATE) AS ultimo_dia
  FROM pedidos
),
dias AS (
  SELECT CAST(t.dia AS DATE) AS dia
  FROM limites, range(limites.primeiro_dia, limites.ultimo_dia + 1, INTERVAL 1 DAY) AS t(dia)
),
meses AS (
  SELECT CAST(date_trunc('month', dia) AS DATE) AS mes, COUNT(*) AS dias_na_base
  FROM dias
  GROUP BY 1
),
grade AS (
  SELECT m.mes, c.categoria, m.dias_na_base
  FROM meses m
  CROSS JOIN (SELECT DISTINCT categoria FROM produtos) c
),
fatos AS (
  SELECT CAST(date_trunc('month', p.data_hora_pedido) AS DATE) AS mes,
         d.categoria,
         COUNT(DISTINCT p.id_pedido) AS pedidos
  FROM pedidos p
  JOIN itens_pedido i USING (id_pedido)
  JOIN produtos d USING (id_produto)
  GROUP BY 1, 2
),
serie AS (
  SELECT g.mes, g.categoria, g.dias_na_base, COALESCE(f.pedidos, 0) AS pedidos
  FROM grade g
  LEFT JOIN fatos f ON f.mes = g.mes AND f.categoria = g.categoria
)
,
caio AS (
  SELECT 'caio, sem calendário' AS versao, mes,
         string_agg(strftime(mes, '%m') || '=' || pedidos, ', ') OVER w AS meses_e_pedidos,
         SUM(pedidos) OVER w AS soma,
         COUNT(*) OVER w AS divide_por,
         ROUND(AVG(pedidos) OVER w, 2) AS media
  FROM fatos
  WHERE categoria = 'Esporte'
  WINDOW w AS (ORDER BY mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
),
calendario AS (
  SELECT 'série completa' AS versao, mes,
         string_agg(strftime(mes, '%m') || '=' || pedidos, ', ') OVER w AS meses_e_pedidos,
         SUM(pedidos) OVER w AS soma,
         COUNT(*) OVER w AS divide_por,
         ROUND(AVG(pedidos) OVER w, 2) AS media
  FROM serie
  WHERE categoria = 'Esporte'
  WINDOW w AS (ORDER BY mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
)
SELECT versao, meses_e_pedidos, soma, divide_por, media
FROM (SELECT * FROM caio UNION ALL SELECT * FROM calendario)
WHERE mes = DATE '2026-06-01'
ORDER BY versao;
