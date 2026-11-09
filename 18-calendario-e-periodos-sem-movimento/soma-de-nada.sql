-- O que COUNT, SUM e AVG retornam quando não sobra nenhuma linha.
-- Julho ainda não aconteceu: nenhuma tentativa tem data em julho.
SELECT COUNT(*) AS linhas,
       COUNT(custo_frete) AS com_custo,
       SUM(custo_frete) AS soma,
       AVG(custo_frete) AS media
FROM entregas
WHERE data_tentativa >= DATE '2026-07-01'
  AND data_tentativa <  DATE '2026-08-01';
