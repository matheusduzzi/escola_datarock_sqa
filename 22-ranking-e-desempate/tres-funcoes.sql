-- As três funções lado a lado, na Casa e no Eletro de fevereiro.
-- RANK e DENSE_RANK olham só as unidades; o ROW_NUMBER usa a regra inteira.
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
)
SELECT categoria, produto, unidades, pedidos,
       ROW_NUMBER() OVER (PARTITION BY categoria
                          ORDER BY unidades DESC, pedidos DESC, id_produto) AS row_number,
       RANK()       OVER (PARTITION BY categoria ORDER BY unidades DESC) AS rank,
       DENSE_RANK() OVER (PARTITION BY categoria ORDER BY unidades DESC) AS dense_rank
FROM vendas
WHERE categoria IN ('Casa', 'Eletro')
ORDER BY categoria, row_number;
