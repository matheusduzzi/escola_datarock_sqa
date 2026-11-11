-- As linhas da tabela entregas de cinco pedidos de maio, com a parte do frete de cada linha.
SELECT e.id_pedido, p.status, e.volume, e.tentativa, e.tipo, e.data_tentativa, e.resultado, e.custo_frete,
       CASE WHEN e.tipo = 'devolucao' THEN 'devolução'
            WHEN e.resultado = 'nao_encontrado' THEN 'tentativa que falhou'
            WHEN e.resultado = 'entregue' THEN 'entrega'
            ELSE 'na rua' END AS parte
FROM entregas e
JOIN pedidos p USING (id_pedido)
WHERE e.id_pedido IN (627, 636, 687, 727, 767)
ORDER BY e.id_pedido, e.tipo DESC, e.volume, e.tentativa;
