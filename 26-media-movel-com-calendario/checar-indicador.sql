-- Antes de mandar o indicador: perguntas com resposta conhecida.
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
janelas AS (
  SELECT mes, categoria, pedidos,
         COUNT(*) OVER w AS meses_na_janela,
         MIN(mes) OVER w AS janela_de,
         SUM(dias_na_base) OVER w AS dias_na_janela,
         SUM(day(last_day(mes))) OVER w AS dias_dos_meses,
         AVG(pedidos) OVER w AS media,
         SUM(pedidos) OVER w AS soma
  FROM serie
  WINDOW w AS (PARTITION BY categoria ORDER BY mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
)
, ind AS (
  SELECT *,
         CASE WHEN meses_na_janela < 3 THEN 'inicial'
              WHEN dias_na_janela < dias_dos_meses THEN 'parcial'
              ELSE 'madura' END AS situacao
  FROM janelas
)
SELECT 'linhas do indicador' AS o_que, CAST(COUNT(*) AS VARCHAR) AS valor FROM ind
UNION ALL SELECT 'meses vezes categorias', CAST((SELECT COUNT(DISTINCT mes) FROM serie) * (SELECT COUNT(DISTINCT categoria) FROM serie) AS VARCHAR)
UNION ALL SELECT 'janelas iniciais', CAST(COUNT(*) FILTER (WHERE situacao = 'inicial') AS VARCHAR) FROM ind
UNION ALL SELECT 'janelas parciais', CAST(COUNT(*) FILTER (WHERE situacao = 'parcial') AS VARCHAR) FROM ind
UNION ALL SELECT 'janelas maduras', CAST(COUNT(*) FILTER (WHERE situacao = 'madura') AS VARCHAR) FROM ind
UNION ALL SELECT 'janelas que pulam mês', CAST(COUNT(*) FILTER (WHERE date_diff('month', janela_de, mes) + 1 <> meses_na_janela) AS VARCHAR) FROM ind
UNION ALL SELECT 'Esporte maio pela soma (55 + 0 + 47) / 3', CAST(ROUND((55 + 0 + 47) / 3, 2) AS VARCHAR)
UNION ALL SELECT 'Esporte maio no indicador', CAST(ROUND(MAX(media) FILTER (WHERE categoria = 'Esporte' AND mes = DATE '2026-05-01'), 2) AS VARCHAR) FROM ind
UNION ALL SELECT 'primeiro mês com janela madura', strftime(MIN(mes) FILTER (WHERE situacao = 'madura'), '%Y-%m') FROM ind;
