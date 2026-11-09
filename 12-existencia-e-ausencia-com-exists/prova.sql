-- A prova da lista da Bruna. Primeiro, a lista do lista-da-bruna.sql. Depois, por outro caminho:
-- uma linha por cliente com a contagem de pedidos de cada status, e as regras aplicadas sobre ela.
CREATE VIEW descadastros AS
SELECT * FROM read_csv('dados/descadastros.csv', header = true);

WITH lista AS (
    SELECT c.id_cliente
    FROM clientes c
    WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.id_cliente = c.id_cliente AND p.status = 'entregue')
      AND NOT EXISTS (SELECT 1 FROM pedidos p WHERE p.id_cliente = c.id_cliente AND p.status = 'devolvido')
      AND NOT EXISTS (SELECT 1 FROM descadastros d WHERE d.id_cliente = c.id_cliente)
), por_cliente AS (
    SELECT c.id_cliente,
           COUNT(p.id_pedido) FILTER (WHERE p.status = 'entregue')  AS entregues,
           COUNT(p.id_pedido) FILTER (WHERE p.status = 'devolvido') AS devolvidos,
           c.id_cliente IN (SELECT id_cliente FROM descadastros WHERE id_cliente IS NOT NULL) AS saiu
    FROM clientes c
    LEFT JOIN pedidos p ON p.id_cliente = c.id_cliente
    GROUP BY c.id_cliente
)
SELECT (SELECT COUNT(*) FROM lista)                                       AS linhas,
       (SELECT COUNT(DISTINCT id_cliente) FROM lista)                     AS clientes,
       COUNT(*) FILTER (WHERE l.id_cliente IS NOT NULL AND pc.entregues = 0)  AS sem_entrega,
       COUNT(*) FILTER (WHERE l.id_cliente IS NOT NULL AND pc.devolvidos > 0) AS com_devolucao,
       COUNT(*) FILTER (WHERE l.id_cliente IS NOT NULL AND pc.saiu)           AS pediram_para_sair,
       COUNT(*) FILTER (WHERE pc.entregues > 0 AND pc.devolvidos = 0 AND NOT pc.saiu) AS pelo_outro_caminho
FROM por_cliente pc
LEFT JOIN lista l ON l.id_cliente = pc.id_cliente;
