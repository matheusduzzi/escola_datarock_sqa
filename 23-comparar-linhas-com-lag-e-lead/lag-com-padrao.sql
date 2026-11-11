-- O LAG com o terceiro argumento: 0 no lugar do NULL quando não há linha de cima.
-- A leitura só olha se o anterior é zero. Mostra janeiro, de todas as categorias.
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
  SELECT CAST(date_trunc('month', dia) AS DATE) AS mes,
         COUNT(*) AS dias_na_base
  FROM dias
  GROUP BY 1
),
categorias AS (
  SELECT DISTINCT categoria FROM produtos
),
grade AS (
  SELECT m.mes, c.categoria, m.dias_na_base
  FROM meses m
  CROSS JOIN categorias c
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
  SELECT g.mes, g.categoria,
         COALESCE(f.pedidos, 0) AS pedidos,
         CASE WHEN g.dias_na_base = day(last_day(g.mes)) THEN 'completo' ELSE 'parcial' END AS situacao
  FROM grade g
  LEFT JOIN fatos f ON f.mes = g.mes AND f.categoria = g.categoria
),
com_anterior AS (
  SELECT mes, categoria, pedidos,
         LAG(pedidos, 1, 0) OVER (PARTITION BY categoria ORDER BY mes) AS anterior
  FROM serie
)
SELECT strftime(mes, '%Y-%m') AS mes,
       categoria,
       pedidos,
       anterior,
       pedidos - anterior AS diferenca,
       CASE WHEN anterior = 0 THEN 'mês anterior sem venda' ELSE 'comparável' END AS leitura
FROM com_anterior
WHERE mes = DATE '2026-01-01'
ORDER BY categoria;
