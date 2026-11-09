-- A grade mês × categoria quando o catálogo tem data de entrada.
-- O catálogo de exemplo abaixo tem as cinco categorias da loja desde 2025 e a Pet a partir de 01/05/2026.
WITH catalogo(categoria, valido_de, valido_ate) AS (
    VALUES ('Beleza',    DATE '2025-01-01', CAST(NULL AS DATE)),
           ('Casa',      DATE '2025-01-01', NULL),
           ('Eletro',    DATE '2025-01-01', NULL),
           ('Esporte',   DATE '2025-01-01', NULL),
           ('Papelaria', DATE '2025-01-01', NULL),
           ('Pet',       DATE '2026-05-01', NULL)
),
meses AS (
    SELECT CAST(m AS DATE) AS inicio, CAST(m + INTERVAL 1 MONTH AS DATE) AS fim
    FROM range(DATE '2026-01-01', DATE '2026-07-01', INTERVAL 1 MONTH) t(m)
)
SELECT 'todo mês com toda categoria' AS grade, COUNT(*) AS linhas,
       COUNT(*) FILTER (WHERE categoria = 'Pet') AS linhas_de_pet
FROM meses CROSS JOIN catalogo
UNION ALL
SELECT 'só a categoria que existia no mês', COUNT(*), COUNT(*) FILTER (WHERE categoria = 'Pet')
FROM meses m
JOIN catalogo c
  ON c.valido_de < m.fim
 AND (c.valido_ate IS NULL OR m.inicio < c.valido_ate)
ORDER BY linhas DESC;
