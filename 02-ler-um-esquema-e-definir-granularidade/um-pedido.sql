-- Um pedido com os itens e as entregas juntados direto pelo id_pedido.
-- Troque o 47 pelo número de outro pedido para ver o que acontece com ele.
SELECT i.n_item, i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0) AS valor_item,
       e.tentativa, e.resultado, e.custo_frete
FROM itens_pedido i
JOIN entregas e ON e.id_pedido = i.id_pedido
WHERE i.id_pedido = 47
ORDER BY i.n_item, e.id_entrega;
