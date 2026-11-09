-- Pedido 2 da prática: a média de 3 meses dos pedidos da loja inteira,
-- sem tabela de meses e com a tabela de meses do calendário da base.
WITH limites AS (
  SELECT CAST(MIN(data_hora_pedido) AS DATE) AS primeiro_dia,
         CAST(MAX(data_hora_pedido) AS DATE) AS ultimo_dia
  FROM pedidos
),
meses AS (
  SELECT CAST(date_trunc('month', CAST(t.dia AS DATE)) AS DATE) AS mes, COUNT(*) AS dias_na_base
  FROM limites, range(limites.primeiro_dia, limites.ultimo_dia + 1, INTERVAL 1 DAY) AS t(dia)
  GROUP BY 1
),
fatos AS (
  SELECT CAST(date_trunc('month', data_hora_pedido) AS DATE) AS mes, COUNT(*) AS pedidos
  FROM pedidos
  GROUP BY 1
),
sem_calendario AS (
  SELECT mes, pedidos,
         ROUND(AVG(pedidos) OVER (ORDER BY mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS media
  FROM fatos
),
com_calendario AS (
  SELECT m.mes, m.dias_na_base, COALESCE(f.pedidos, 0) AS pedidos
  FROM meses m
  LEFT JOIN fatos f ON f.mes = m.mes
)
SELECT strftime(c.mes, '%Y-%m') AS mes,
       c.pedidos,
       s.media AS media_sem_calendario,
       ROUND(AVG(c.pedidos) OVER w, 2) AS media_com_calendario,
       COUNT(*) OVER w AS meses_na_janela,
       c.dias_na_base
FROM com_calendario c
LEFT JOIN sem_calendario s ON s.mes = c.mes
WINDOW w AS (ORDER BY c.mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
ORDER BY c.mes;
