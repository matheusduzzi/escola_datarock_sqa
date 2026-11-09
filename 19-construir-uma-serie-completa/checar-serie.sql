-- Checagem da série. A primeira parte é a serie-completa.sql inteira, guardada como uma view.
-- Depois, cada linha do resultado é uma pergunta sobre a série e a resposta.
CREATE TEMP VIEW serie AS
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
)
SELECT strftime(g.mes, '%Y-%m') AS mes,
       g.categoria,
       COALESCE(f.pedidos, 0) AS pedidos,
       day(last_day(g.mes)) AS dias_no_mes,
       g.dias_na_base,
       CASE WHEN g.dias_na_base = day(last_day(g.mes)) THEN 'completo' ELSE 'parcial' END AS situacao
FROM grade g
LEFT JOIN fatos f ON f.mes = g.mes AND f.categoria = g.categoria
ORDER BY g.mes, g.categoria;

SELECT o_que, valor
FROM (
  SELECT 1 AS ordem, 'linhas da série' AS o_que, COUNT(*) AS valor FROM serie
  UNION ALL
  SELECT 2, 'meses vezes categorias', COUNT(DISTINCT mes) * COUNT(DISTINCT categoria) FROM serie
  UNION ALL
  SELECT 3, 'linhas repetidas (mês e categoria)', COUNT(*) - COUNT(DISTINCT (mes, categoria)) FROM serie
  UNION ALL
  SELECT 4, 'soma dos pedidos da série', SUM(pedidos) FROM serie
  UNION ALL
  SELECT 5, 'pares pedido e categoria na base', COUNT(DISTINCT (i.id_pedido, d.categoria))
  FROM itens_pedido i JOIN produtos d USING (id_produto)
  UNION ALL
  SELECT 6, 'pedidos na base', COUNT(*) FROM pedidos
  UNION ALL
  SELECT 7, 'linhas com zero', COUNT(*) FILTER (WHERE pedidos = 0) FROM serie
  UNION ALL
  SELECT 8, 'linhas de mês parcial', COUNT(*) FILTER (WHERE situacao = 'parcial') FROM serie
  UNION ALL
  SELECT 9, 'meses depois do último pedido', COUNT(*) FILTER (WHERE mes > (SELECT strftime(MAX(data_hora_pedido), '%Y-%m') FROM pedidos)) FROM serie
)
ORDER BY ordem;
