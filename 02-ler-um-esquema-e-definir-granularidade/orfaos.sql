-- Linhas que apontam para um pedido ou produto que não existe.
-- O CSV não tem chave estrangeira: ninguém impede uma linha assim de entrar.
SELECT
    (SELECT COUNT(*) FROM itens_pedido i
      WHERE NOT EXISTS (SELECT 1 FROM pedidos p WHERE p.id_pedido = i.id_pedido))  AS itens_sem_pedido,
    (SELECT COUNT(*) FROM itens_pedido i
      WHERE NOT EXISTS (SELECT 1 FROM produtos d WHERE d.id_produto = i.id_produto)) AS itens_sem_produto,
    (SELECT COUNT(*) FROM entregas e
      WHERE NOT EXISTS (SELECT 1 FROM pedidos p WHERE p.id_pedido = e.id_pedido))  AS entregas_sem_pedido;
