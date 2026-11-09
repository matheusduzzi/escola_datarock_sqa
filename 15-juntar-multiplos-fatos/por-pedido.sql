-- Somar cada fato no grão do pedido e só depois juntar.
WITH itens AS (
    SELECT id_pedido,
           SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS valor_itens
    FROM itens_pedido
    GROUP BY id_pedido
),
pagos AS (
    SELECT id_pedido,
           SUM(CASE status WHEN 'aprovado' THEN valor
                           WHEN 'estornado' THEN -valor
                           ELSE 0 END) AS recebido
    FROM pagamentos
    GROUP BY id_pedido
),
viagens AS (
    SELECT id_pedido,
           SUM(custo_frete) AS frete
    FROM entregas
    GROUP BY id_pedido
),
por_pedido AS (
    SELECT p.id_pedido, p.status, it.valor_itens,
           COALESCE(pg.recebido, 0) AS recebido,
           v.frete
    FROM pedidos p
    LEFT JOIN itens it  ON it.id_pedido = p.id_pedido
    LEFT JOIN pagos pg  ON pg.id_pedido = p.id_pedido
    LEFT JOIN viagens v ON v.id_pedido = p.id_pedido
)
-- A prova: uma linha por pedido, e cada soma igual à da tabela sozinha.
SELECT 'juntado por pedido' AS origem,
       COUNT(*)                   AS linhas,
       ROUND(SUM(valor_itens), 2) AS valor_itens,
       ROUND(SUM(recebido), 2)    AS recebido,
       ROUND(SUM(frete), 2)       AS frete
FROM por_pedido
UNION ALL
SELECT 'cada tabela sozinha',
       (SELECT COUNT(*) FROM pedidos),
       (SELECT ROUND(SUM(quantidade * preco_unitario - COALESCE(desconto, 0)), 2) FROM itens_pedido),
       (SELECT ROUND(SUM(CASE status WHEN 'aprovado' THEN valor
                                     WHEN 'estornado' THEN -valor
                                     ELSE 0 END), 2) FROM pagamentos),
       (SELECT ROUND(SUM(custo_frete), 2) FROM entregas);
