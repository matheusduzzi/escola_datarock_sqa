-- Onde cada dependência quebrou: o dono, os valores que aparecem e em quantas linhas cada um.
WITH valores AS (
    SELECT 'cliente ' || id_cliente AS dono, cidade AS valor, COUNT(*) AS linhas FROM vendas_larga GROUP BY ALL
    UNION ALL
    SELECT 'produto ' || id_produto, categoria, COUNT(*) FROM vendas_larga GROUP BY ALL
    UNION ALL
    SELECT 'pedido ' || id_pedido, status, COUNT(*) FROM vendas_larga GROUP BY ALL
)
SELECT dono, STRING_AGG(valor || ' (' || linhas || ')', ', ' ORDER BY linhas DESC) AS valores
FROM valores
GROUP BY dono
HAVING COUNT(*) > 1
ORDER BY dono;
