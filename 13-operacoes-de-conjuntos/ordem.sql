-- Qual operação roda primeiro? O INTERSECT vem antes do UNION.
SELECT 1 AS x
UNION
SELECT 2
INTERSECT
SELECT 3;
