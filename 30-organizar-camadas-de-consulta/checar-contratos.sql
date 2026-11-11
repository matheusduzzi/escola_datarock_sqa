-- Testa cada contrato com uma pergunta de resposta conhecida.
-- O "esperado" sai da camada de baixo ou do CSV, nunca da própria view.
-- Rode o montar.sql antes.
ATTACH 'loja.duckdb' AS loja (READ_ONLY);

WITH checagens AS (
    SELECT 1 AS n, 'prep_pedidos' AS view, 'mesmas linhas do CSV' AS regra,
           (SELECT COUNT(*) FROM pedidos)::VARCHAR AS esperado,
           (SELECT COUNT(*) FROM loja.prep_pedidos)::VARCHAR AS obtido
    UNION ALL SELECT 2, 'prep_itens', 'mesmas linhas do CSV',
           (SELECT COUNT(*) FROM itens_pedido)::VARCHAR,
           (SELECT COUNT(*) FROM loja.prep_itens)::VARCHAR
    UNION ALL SELECT 3, 'prep_itens', 'valor_item nunca vazio',
           '0',
           (SELECT COUNT(*) FROM loja.prep_itens WHERE valor_item IS NULL)::VARCHAR
    UNION ALL SELECT 4, 'prep_pagamentos', 'mesmas linhas do CSV',
           (SELECT COUNT(*) FROM pagamentos)::VARCHAR,
           (SELECT COUNT(*) FROM loja.prep_pagamentos)::VARCHAR
    UNION ALL SELECT 5, 'regra_pedido', 'uma linha por pedido',
           (SELECT COUNT(*) FROM loja.prep_pedidos)::VARCHAR,
           (SELECT COUNT(*) FROM loja.regra_pedido)::VARCHAR
    UNION ALL SELECT 6, 'regra_pedido', 'id_pedido sem repetir',
           '0',
           (SELECT COUNT(*) - COUNT(DISTINCT id_pedido) FROM loja.regra_pedido)::VARCHAR
    UNION ALL SELECT 7, 'regra_pedido', 'valor nunca vazio',
           '0',
           (SELECT COUNT(*) FROM loja.regra_pedido WHERE valor IS NULL)::VARCHAR
    UNION ALL SELECT 8, 'regra_pedido', 'soma do valor = soma dos itens',
           (SELECT SUM(valor_item) FROM loja.prep_itens)::VARCHAR,
           (SELECT SUM(valor) FROM loja.regra_pedido)::VARCHAR
    UNION ALL SELECT 9, 'consumo_painel_mes', 'uma linha por mês',
           (SELECT COUNT(DISTINCT mes) FROM loja.regra_pedido)::VARCHAR,
           (SELECT COUNT(*) FROM loja.consumo_painel_mes)::VARCHAR
    UNION ALL SELECT 10, 'consumo_painel_mes', 'soma do vendido = regra',
           (SELECT ROUND(SUM(valor), 2) FROM loja.regra_pedido WHERE conta_como_venda)::VARCHAR,
           (SELECT SUM(vendido) FROM loja.consumo_painel_mes)::VARCHAR
    UNION ALL SELECT 11, 'consumo_painel_mes', 'soma do recebido = regra',
           (SELECT ROUND(SUM(recebido), 2) FROM loja.regra_pedido)::VARCHAR,
           (SELECT SUM(recebido) FROM loja.consumo_painel_mes)::VARCHAR
    UNION ALL SELECT 12, 'consumo_cobranca', 'soma do que falta = regra',
           (SELECT SUM(falta_receber) FROM loja.regra_pedido)::VARCHAR,
           (SELECT COALESCE(SUM(falta_receber), 0) FROM loja.consumo_cobranca)::VARCHAR
)
SELECT view, regra, esperado, obtido, CASE WHEN esperado = obtido THEN 'ok' ELSE 'FALHOU' END AS situacao
FROM checagens
ORDER BY n;
