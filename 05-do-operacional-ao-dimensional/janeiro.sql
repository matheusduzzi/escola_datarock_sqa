-- Os dois números de janeiro, lado a lado.
-- caio: quantidade vezes o preço de tabela do produto, todos os pedidos.
-- Nas colunas seguintes, uma regra muda por vez, até chegar no meu número.
SELECT ROUND(SUM(i.quantidade * d.preco_lista), 2)                          AS caio,
       ROUND(SUM(i.quantidade * i.preco_unitario), 2)                       AS preco_pago,
       ROUND(SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)), 2) AS menos_desconto,
       ROUND(SUM(CASE WHEN p.status IN ('entregue', 'em_andamento')
                      THEN i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0) END), 2) AS sem_cancelado_devolvido
FROM itens_pedido i
JOIN pedidos p  ON p.id_pedido = i.id_pedido
JOIN produtos d ON d.id_produto = i.id_produto
WHERE p.data_hora_pedido >= TIMESTAMP '2026-01-01'
  AND p.data_hora_pedido <  TIMESTAMP '2026-02-01';
