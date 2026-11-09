-- A consulta do Caio: uma linha por categoria e status, contando linhas de item.
-- Ele copiou essa saída para a planilha e dividiu os devolvidos pelo total da categoria.
SELECT d.categoria,
       p.status,
       COUNT(*) AS linhas
FROM itens_pedido i
JOIN pedidos  p ON p.id_pedido  = i.id_pedido
JOIN produtos d ON d.id_produto = i.id_produto
GROUP BY d.categoria, p.status
ORDER BY d.categoria, p.status;
