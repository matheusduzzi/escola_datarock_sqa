-- Uma linha por pedido: cada tabela filha é somada no grão do pedido antes de juntar.
-- No fim, os totais e o número de linhas para comparar com cada tabela.
WITH
itens AS (
    SELECT id_pedido, SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS valor_itens
    FROM itens_pedido GROUP BY id_pedido),
frete AS (
    SELECT id_pedido, SUM(custo_frete) AS frete
    FROM entregas GROUP BY id_pedido),
por_pedido AS (
    SELECT p.id_pedido, p.status, i.valor_itens, f.frete
    FROM pedidos p
    LEFT JOIN itens i ON i.id_pedido = p.id_pedido
    LEFT JOIN frete f ON f.id_pedido = p.id_pedido)
SELECT COUNT(*) AS linhas,
       COUNT(DISTINCT id_pedido) AS pedidos,
       ROUND(SUM(valor_itens), 2) AS valor_itens,
       ROUND(SUM(frete), 2) AS frete,
       COUNT(*) FILTER (WHERE frete IS NULL) AS sem_frete
FROM por_pedido;
