-- Quatro respostas para "quanto custa o frete de um pedido em maio".
-- Cada linha muda uma escolha: o que entra no frete, o que divide e qual data diz o mês.
WITH pedidos_de_maio AS (
    SELECT id_pedido, status
    FROM pedidos
    WHERE data_hora_pedido >= TIMESTAMP '2026-05-01 00:00:00'
      AND data_hora_pedido <  TIMESTAMP '2026-06-01 00:00:00'
      AND status <> 'cancelado'
),
linhas AS (
    SELECT e.*
    FROM entregas e
    WHERE e.id_pedido IN (SELECT id_pedido FROM pedidos_de_maio)
),
respostas AS (
    SELECT 1 AS n,
           'A. só a entrega que deu certo / pedidos entregues' AS leitura,
           SUM(custo_frete) FILTER (WHERE tipo = 'ida' AND resultado = 'entregue') AS frete,
           (SELECT COUNT(*) FROM pedidos_de_maio WHERE status = 'entregue') AS divide_por
    FROM linhas
    UNION ALL
    SELECT 2, 'B. tudo que a transportadora cobrou / pedidos feitos em maio',
           SUM(custo_frete), (SELECT COUNT(*) FROM pedidos_de_maio)
    FROM linhas
    UNION ALL
    SELECT 3, 'C. tudo que a transportadora cobrou / volumes entregues',
           SUM(custo_frete), COUNT(*) FILTER (WHERE tipo = 'ida' AND resultado = 'entregue')
    FROM linhas
    UNION ALL
    SELECT 4, 'D. tentativas feitas em maio / pedidos com tentativa em maio',
           SUM(custo_frete), COUNT(DISTINCT id_pedido)
    FROM entregas
    WHERE data_tentativa >= DATE '2026-05-01' AND data_tentativa < DATE '2026-06-01'
)
SELECT leitura, ROUND(frete, 2) AS frete, divide_por, ROUND(frete / divide_por, 2) AS por_pedido
FROM respostas
ORDER BY n;
