-- Primeira tentativa: acumulado com ORDER BY mes e sem PARTITION BY.
-- Mostra só janeiro e fevereiro para caber na tela.
WITH vendas AS (
    SELECT strftime(p.data_hora_pedido, '%Y-%m') AS mes,
           d.categoria,
           SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor
    FROM pedidos p
    JOIN itens_pedido i USING (id_pedido)
    JOIN produtos d USING (id_produto)
    WHERE p.status <> 'cancelado'
    GROUP BY 1, 2
),
com_acumulado AS (
    SELECT mes, categoria, valor,
           SUM(valor) OVER (ORDER BY mes) AS acumulado
    FROM vendas
)
SELECT mes, categoria, ROUND(valor, 2) AS valor, ROUND(acumulado, 2) AS acumulado
FROM com_acumulado
WHERE mes <= '2026-02'
ORDER BY mes, categoria;
