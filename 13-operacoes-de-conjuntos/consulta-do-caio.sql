-- A consulta que o Caio mandou para a Helena.
WITH bipadas AS (
    SELECT produto FROM doca1
    UNION
    SELECT produto FROM doca2
)
SELECT (SELECT COUNT(*) FROM bipadas) AS caixas_bipadas,
       (SELECT string_agg(produto, ', ' ORDER BY produto)
        FROM (SELECT produto FROM romaneio
              EXCEPT
              SELECT produto FROM bipadas)) AS faltou;
