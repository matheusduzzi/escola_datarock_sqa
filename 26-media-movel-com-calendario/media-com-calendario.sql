-- A média de 3 meses sobre a série completa da aula 19:
-- uma linha por mês e categoria, com zero onde a categoria não vendeu. Só Esporte.
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
SELECT strftime(mes, '%Y-%m') AS mes,
       pedidos,
       strftime(MIN(mes) OVER w, '%Y-%m') AS janela_de,
       COUNT(*) OVER w AS meses_na_janela,
       ROUND(AVG(pedidos) OVER w, 2) AS media_3_meses
FROM serie
WHERE categoria = 'Esporte'
WINDOW w AS (PARTITION BY categoria ORDER BY mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
ORDER BY mes;
