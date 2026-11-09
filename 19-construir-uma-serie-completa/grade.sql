-- A grade da série: cada mês da tabela de meses com cada categoria do catálogo.
-- Ainda sem pedido nenhum. Mostra o tamanho da grade e se a linha de Esporte em abril existe.
WITH meses AS (
  SELECT CAST(inicio AS DATE) AS mes
  FROM range(TIMESTAMP '2026-01-01', TIMESTAMP '2026-07-01', INTERVAL 1 MONTH) AS t(inicio)
),
categorias AS (
  SELECT DISTINCT categoria FROM produtos
),
grade AS (
  SELECT m.mes, c.categoria
  FROM meses m
  CROSS JOIN categorias c
)
SELECT COUNT(DISTINCT mes) AS meses,
       COUNT(DISTINCT categoria) AS categorias,
       COUNT(*) AS linhas,
       COUNT(*) FILTER (WHERE mes = DATE '2026-04-01' AND categoria = 'Esporte') AS linhas_esporte_abril
FROM grade;
