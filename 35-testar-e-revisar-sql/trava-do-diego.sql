-- Os testes que param a execução, rodando sobre a etapa por pedido do Diego.
-- Se algum teste falha, o DuckDB para com erro e o consultar.py sai com código 1.
WITH recorte AS (
  SELECT id_pedido FROM pedidos
  WHERE status <> 'cancelado'
    AND data_hora_pedido >= TIMESTAMP '2026-06-01 00:00:00'
    AND data_hora_pedido <  TIMESTAMP '2026-06-21 00:00:00'
),
por_pedido AS (
  SELECT p.id_pedido,
         SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor_itens,
         SUM(g.valor) AS recebido
  FROM pedidos p
  JOIN itens_pedido i ON i.id_pedido = p.id_pedido
  LEFT JOIN entregas e ON e.id_pedido = p.id_pedido
  LEFT JOIN pagamentos g ON g.id_pedido = p.id_pedido AND g.status = 'aprovado'
  WHERE p.status <> 'cancelado'
    AND p.data_hora_pedido BETWEEN '2026-06-01' AND '2026-06-20'
  GROUP BY p.id_pedido
),
falhas AS (
  SELECT 'pedidos do recorte que faltam: ' || COUNT(*) AS falha
  FROM recorte WHERE id_pedido NOT IN (SELECT id_pedido FROM por_pedido)
  HAVING COUNT(*) > 0
  UNION ALL
  SELECT 'pedidos repetidos: ' || (COUNT(*) - COUNT(DISTINCT id_pedido))
  FROM por_pedido
  HAVING COUNT(*) > COUNT(DISTINCT id_pedido)
  UNION ALL
  SELECT 'faturamento ' || ROUND(SUM(valor_itens), 2) || ' contra ' || ROUND(MAX(t.total), 2) || ' nas tabelas'
  FROM por_pedido,
       (SELECT SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS total
        FROM itens_pedido WHERE id_pedido IN (SELECT id_pedido FROM recorte)) t
  HAVING ROUND(SUM(valor_itens), 2) <> ROUND(MAX(t.total), 2)
  UNION ALL
  SELECT 'pedidos com a receber vazio: ' || COUNT(*)
  FROM por_pedido WHERE valor_itens - recebido IS NULL
  HAVING COUNT(*) > 0
)
SELECT CASE WHEN COUNT(*) = 0 THEN 'os 4 testes passaram'
            ELSE error('teste falhou: ' || string_agg(falha, '; ')) END AS resultado
FROM falhas
