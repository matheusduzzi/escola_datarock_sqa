-- A regra da Lúcia com um DESC a menos: o pedidos ficou em ordem crescente.
-- Mostra só as posições da vitrine em que as duas versões escolhem produtos diferentes.
WITH vendas AS (
    SELECT d.categoria, d.id_produto, d.nome AS produto,
           SUM(i.quantidade) AS unidades,
           COUNT(DISTINCT p.id_pedido) AS pedidos
    FROM pedidos p
    JOIN itens_pedido i USING (id_pedido)
    JOIN produtos d USING (id_produto)
    WHERE p.status = 'entregue'
      AND p.data_hora_pedido >= '2026-02-01' AND p.data_hora_pedido < '2026-03-01'
    GROUP BY 1, 2, 3
),
ranking AS (
    SELECT categoria, produto,
           ROW_NUMBER() OVER (PARTITION BY categoria
                              ORDER BY unidades DESC, pedidos DESC, id_produto) AS com_a_regra,
           ROW_NUMBER() OVER (PARTITION BY categoria
                              ORDER BY unidades DESC, pedidos, id_produto) AS com_desc_esquecido
    FROM vendas
)
SELECT a.categoria, a.com_a_regra AS posicao,
       a.produto AS com_a_regra, b.produto AS com_desc_esquecido
FROM ranking a
JOIN ranking b ON b.categoria = a.categoria AND b.com_desc_esquecido = a.com_a_regra
WHERE a.com_a_regra <= 3 AND a.produto <> b.produto
ORDER BY a.categoria, posicao;
