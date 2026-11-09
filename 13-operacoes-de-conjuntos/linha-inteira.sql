-- UNION com SELECT *: a linha inteira entra na comparação, inclusive a hora.
SELECT COUNT(*) AS linhas
FROM (SELECT * FROM doca1
      UNION
      SELECT * FROM doca2);
