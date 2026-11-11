-- Por que o frete dos pedidos de maio (3161.70) e o frete das tentativas de maio (3141.60) não batem.
-- Rodar: python3 projeto.py etapas.sql pedidos-e-tentativas.sql
-- Cada linha de cobrancas de maio cai em um de três grupos, pelo mês do pedido e pelo mês da tentativa.
WITH grupos AS (
    SELECT CASE WHEN mes_pedido = DATE '2026-05-01' AND mes_tentativa = DATE '2026-05-01'
                     THEN '1. pedido de maio, tentativa em maio'
                WHEN mes_pedido = DATE '2026-05-01'
                     THEN '2. pedido de maio, tentativa em junho'
                WHEN mes_tentativa = DATE '2026-05-01'
                     THEN '3. pedido de abril, tentativa em maio'
           END AS grupo,
           custo_frete
    FROM cobrancas
    WHERE mes_pedido = DATE '2026-05-01' OR mes_tentativa = DATE '2026-05-01'
)
SELECT grupo,
       COUNT(*)                                   AS linhas,
       ROUND(SUM(custo_frete), 2)                 AS frete,
       CASE WHEN grupo LIKE '3.%' THEN '' ELSE 'x' END AS pedidos_de_maio,
       CASE WHEN grupo LIKE '2.%' THEN '' ELSE 'x' END AS tentativas_de_maio
FROM grupos
GROUP BY grupo
ORDER BY grupo;
