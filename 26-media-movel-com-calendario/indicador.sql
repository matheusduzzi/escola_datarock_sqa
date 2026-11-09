-- O indicador da reunião: média de 3 meses por categoria, sobre a série completa,
-- com a situação de cada janela. Inicial: menos de 3 meses na base. Parcial: algum mês
-- da janela sem todos os dias. Madura: 3 meses inteiros. A média por mês só sai na madura.
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
SELECT strftime(mes, '%Y-%m') AS mes,
       categoria,
       pedidos,
       meses_na_janela,
       dias_na_janela,
       CASE WHEN meses_na_janela < 3 THEN 'inicial'
            WHEN dias_na_janela < dias_dos_meses THEN 'parcial'
            ELSE 'madura' END AS situacao,
       CASE WHEN meses_na_janela = 3 AND dias_na_janela = dias_dos_meses THEN ROUND(media, 2) END AS media_3_meses,
       CASE WHEN meses_na_janela = 3 THEN ROUND(soma / dias_na_janela, 2) END AS pedidos_por_dia
FROM janelas
ORDER BY mes, categoria;
