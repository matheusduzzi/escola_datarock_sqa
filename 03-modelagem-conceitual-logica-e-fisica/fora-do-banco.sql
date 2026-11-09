-- Regras de negócio que olham mais de uma linha ou mais de uma tabela.
-- O banco não guarda essas regras; quem testa é esta consulta.
-- Cada linha é uma regra e a última coluna conta quantas linhas a desobedecem.

SELECT 1 AS n, 'devolução só em pedido devolvido' AS regra, COUNT(*) AS linhas_que_quebram
FROM entregas e
JOIN pedidos p ON p.id_pedido = e.id_pedido
WHERE e.tipo = 'devolucao' AND p.status <> 'devolvido'

UNION ALL
SELECT 2, 'pedido devolvido tem uma devolução', COUNT(*)
FROM pedidos p
WHERE p.status = 'devolvido'
  AND (SELECT COUNT(*) FROM entregas e
       WHERE e.id_pedido = p.id_pedido AND e.tipo = 'devolucao') <> 1

UNION ALL
SELECT 3, 'nova tentativa só depois de uma que não entregou', COUNT(*)
FROM entregas e
WHERE e.tipo = 'ida' AND e.tentativa > 1
  AND NOT EXISTS (SELECT 1 FROM entregas a
                  WHERE a.id_pedido = e.id_pedido AND a.tipo = 'ida' AND a.volume = e.volume
                    AND a.tentativa = e.tentativa - 1 AND a.resultado = 'nao_encontrado')

UNION ALL
SELECT 4, 'pedido cancelado não sai para entrega', COUNT(*)
FROM entregas e
JOIN pedidos p ON p.id_pedido = e.id_pedido
WHERE p.status = 'cancelado'

ORDER BY n;
