-- A consulta do Caio: pedidos, itens e entregas juntados direto pelo id_pedido.
-- Ao lado, os mesmos totais calculados em cada tabela, sem juntar.
WITH juntado AS (
    SELECT i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0) AS valor_item, e.custo_frete
    FROM pedidos p
    JOIN itens_pedido i ON i.id_pedido = p.id_pedido
    JOIN entregas e ON e.id_pedido = p.id_pedido)
SELECT
    (SELECT COUNT(*) FROM juntado)                                   AS linhas_juntadas,
    (SELECT ROUND(SUM(custo_frete), 2) FROM juntado)                 AS frete_juntado,
    (SELECT ROUND(SUM(custo_frete), 2) FROM entregas)                AS frete_entregas,
    (SELECT ROUND(SUM(valor_item), 2) FROM juntado)                  AS itens_juntado,
    (SELECT ROUND(SUM(quantidade * preco_unitario - COALESCE(desconto, 0)), 2)
       FROM itens_pedido)                                            AS itens_tabela;
