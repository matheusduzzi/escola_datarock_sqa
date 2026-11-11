-- A regra_pedido que o Caio sugeriu: "um JOIN só, sem as duas CTEs".
-- Ela fica numa view temporária, que some no fim do comando, e passa pelas
-- mesmas checagens da regra. Rode o montar.sql antes.
ATTACH 'loja.duckdb' AS loja (READ_ONLY);

CREATE TEMP VIEW regra_pedido_caio AS
SELECT p.id_pedido, p.mes, p.canal, p.status,
       SUM(i.valor_item) AS valor,
       SUM(g.valor) AS recebido,
       p.status = 'entregue' AS conta_como_venda
FROM loja.prep_pedidos p
JOIN loja.prep_itens i ON i.id_pedido = p.id_pedido
JOIN loja.prep_pagamentos g ON g.id_pedido = p.id_pedido AND g.status = 'aprovado'
GROUP BY p.id_pedido, p.mes, p.canal, p.status;

WITH checagens AS (
    SELECT 5 AS n, 'uma linha por pedido' AS regra,
           (SELECT COUNT(*) FROM loja.prep_pedidos)::VARCHAR AS esperado,
           (SELECT COUNT(*) FROM regra_pedido_caio)::VARCHAR AS obtido
    UNION ALL SELECT 6, 'id_pedido sem repetir', '0',
           (SELECT COUNT(*) - COUNT(DISTINCT id_pedido) FROM regra_pedido_caio)::VARCHAR
    UNION ALL SELECT 7, 'valor nunca vazio', '0',
           (SELECT COUNT(*) FROM regra_pedido_caio WHERE valor IS NULL)::VARCHAR
    UNION ALL SELECT 8, 'soma do valor = soma dos itens',
           (SELECT SUM(valor_item) FROM loja.prep_itens)::VARCHAR,
           (SELECT SUM(valor) FROM regra_pedido_caio)::VARCHAR
)
SELECT 'regra_pedido_caio' AS view, regra, esperado, obtido,
       CASE WHEN esperado = obtido THEN 'ok' ELSE 'FALHOU' END AS situacao
FROM checagens
ORDER BY n;
