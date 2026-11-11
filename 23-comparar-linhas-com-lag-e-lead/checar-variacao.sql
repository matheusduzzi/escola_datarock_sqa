-- Perguntas com resposta conhecida sobre a variação da reunião.
-- Primeiro guarda o variacao-mensal.sql como uma view, depois pergunta sobre ela.
CREATE TEMP VIEW variacao AS
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
  SELECT mes, categoria, pedidos, situacao,
         LAG(mes) OVER (PARTITION BY categoria ORDER BY mes) AS mes_de_cima,
         LAG(pedidos) OVER (PARTITION BY categoria ORDER BY mes) AS anterior
  FROM serie
),
lida AS (
  SELECT *,
         CASE
           WHEN mes_de_cima IS NULL THEN 'sem mês anterior na base'
           WHEN date_diff('month', mes_de_cima, mes) <> 1 THEN 'linha de cima não é o mês anterior'
           WHEN situacao = 'parcial' THEN 'mês parcial'
           WHEN anterior = 0 THEN 'mês anterior sem venda'
           ELSE 'comparável'
         END AS leitura
  FROM com_anterior
)
SELECT strftime(mes, '%Y-%m') AS mes,
       categoria,
       pedidos,
       anterior,
       pedidos - anterior AS diferenca,
       CASE WHEN leitura = 'comparável'
            THEN ROUND(100.0 * (pedidos - anterior) / anterior, 1) END AS variacao_pct,
       leitura
FROM lida
ORDER BY mes, categoria;

WITH pontas AS (
  SELECT categoria,
         SUM(diferenca) AS soma_das_diferencas,
         MAX(CASE WHEN mes = '2026-06' THEN pedidos END) - MAX(CASE WHEN mes = '2026-01' THEN pedidos END) AS junho_menos_janeiro
  FROM variacao
  GROUP BY categoria
)
SELECT o_que, valor FROM (
  SELECT 1 AS ordem, 'linhas da variação' AS o_que, COUNT(*) AS valor FROM variacao
  UNION ALL SELECT 2, 'meses vezes categorias', COUNT(DISTINCT mes) * COUNT(DISTINCT categoria) FROM variacao
  UNION ALL SELECT 3, 'linhas em que a de cima não é o mês anterior', COUNT(*) FILTER (WHERE leitura = 'linha de cima não é o mês anterior') FROM variacao
  UNION ALL SELECT 4, 'sem mês anterior na base', COUNT(*) FILTER (WHERE leitura = 'sem mês anterior na base') FROM variacao
  UNION ALL SELECT 5, 'mês anterior sem venda', COUNT(*) FILTER (WHERE leitura = 'mês anterior sem venda') FROM variacao
  UNION ALL SELECT 6, 'mês parcial', COUNT(*) FILTER (WHERE leitura = 'mês parcial') FROM variacao
  UNION ALL SELECT 7, 'comparável', COUNT(*) FILTER (WHERE leitura = 'comparável') FROM variacao
  UNION ALL SELECT 8, 'variação com número em linha não comparável', COUNT(*) FILTER (WHERE leitura <> 'comparável' AND variacao_pct IS NOT NULL) FROM variacao
  UNION ALL SELECT 9, 'variação inf ou nan', COUNT(*) FILTER (WHERE isinf(variacao_pct) OR isnan(variacao_pct)) FROM variacao
  UNION ALL SELECT 10, 'categorias em que as diferenças somam junho menos janeiro', COUNT(*) FILTER (WHERE soma_das_diferencas = junho_menos_janeiro) FROM pontas
)
ORDER BY ordem;
