-- A série da aula 19 (uma linha por mês e categoria, com zero onde a categoria não vendeu)
-- e, por cima dela, o LAG do Caio, com a mesma conta de variação. Mostra só Esporte.
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
         LAG(pedidos) OVER (PARTITION BY categoria ORDER BY mes) AS mes_anterior
  FROM serie
)
SELECT strftime(mes, '%Y-%m') AS mes,
       pedidos,
       mes_anterior,
       ROUND(100.0 * (pedidos - mes_anterior) / mes_anterior, 1) AS variacao_pct
FROM com_anterior
WHERE categoria = 'Esporte'
ORDER BY mes;
