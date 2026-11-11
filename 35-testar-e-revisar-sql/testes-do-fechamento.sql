-- Testes do fechamento parcial de junho.
-- A coluna esperado sai das tabelas, sem a consulta que está sendo testada.
-- As colunas diego e revisada rodam o mesmo teste em cada versão.
WITH
-- O recorte do pedido da Sônia: não cancelados, de 01/06 00:00 até antes de 21/06 00:00.
recorte AS (
  SELECT id_pedido, data_hora_pedido FROM pedidos
  WHERE status <> 'cancelado'
    AND data_hora_pedido >= TIMESTAMP '2026-06-01 00:00:00'
    AND data_hora_pedido <  TIMESTAMP '2026-06-21 00:00:00'
),
-- A etapa por pedido do Diego, copiada da consulta dele.
diego AS (
  SELECT p.id_pedido,
         SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS valor_itens,
         SUM(e.custo_frete) AS frete,
         CAST(NULL AS BIGINT) AS entregas_sem_fatura,  -- a consulta dele não tem essa coluna
         SUM(g.valor) AS recebido
  FROM pedidos p
  JOIN itens_pedido i ON i.id_pedido = p.id_pedido
  LEFT JOIN entregas e ON e.id_pedido = p.id_pedido
  LEFT JOIN pagamentos g ON g.id_pedido = p.id_pedido AND g.status = 'aprovado'
  WHERE p.status <> 'cancelado'
    AND p.data_hora_pedido BETWEEN '2026-06-01' AND '2026-06-20'
  GROUP BY p.id_pedido
),
-- A etapa por pedido da versão revisada, copiada de fechamento-revisado.sql, com o recorte dela.
revisada AS (
  WITH recorte AS (
    SELECT id_pedido FROM pedidos
    WHERE status <> 'cancelado'
      AND data_hora_pedido >= TIMESTAMP '2026-06-01 00:00:00'
      AND data_hora_pedido <  TIMESTAMP '2026-06-21 00:00:00'
  ),
  itens AS (
    SELECT id_pedido, SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS valor_itens
    FROM itens_pedido GROUP BY id_pedido
  ),
  fretes AS (
    SELECT id_pedido, SUM(custo_frete) AS frete, COUNT(*) - COUNT(custo_frete) AS entregas_sem_fatura
    FROM entregas GROUP BY id_pedido
  ),
  pagos AS (
    SELECT id_pedido, SUM(valor) AS recebido
    FROM pagamentos WHERE status = 'aprovado' GROUP BY id_pedido
  )
  SELECT r.id_pedido, i.valor_itens, f.frete, f.entregas_sem_fatura,
         COALESCE(g.recebido, 0) AS recebido
  FROM recorte r
  LEFT JOIN itens i  ON i.id_pedido = r.id_pedido
  LEFT JOIN fretes f ON f.id_pedido = r.id_pedido
  LEFT JOIN pagos g  ON g.id_pedido = r.id_pedido
),
versoes AS (
  SELECT 'diego' AS versao, * FROM diego
  UNION ALL
  SELECT 'revisada', * FROM revisada
),
-- Os mesmos testes para as duas versões. Dinheiro com duas casas, contagem inteira.
testes AS (
  SELECT versao, 1 AS n, 'chave: pedidos repetidos' AS teste,
         CAST(COUNT(*) - COUNT(DISTINCT id_pedido) AS VARCHAR) AS valor
  FROM versoes GROUP BY versao
  UNION ALL
  SELECT versao, 2, 'chave: pedidos do recorte que faltam',
         CAST(COUNT(*) FILTER (WHERE id_pedido NOT IN (SELECT id_pedido FROM versoes x WHERE x.versao = v.versao)) AS VARCHAR)
  FROM (SELECT DISTINCT versao FROM versoes) v CROSS JOIN recorte GROUP BY versao
  UNION ALL
  SELECT versao, 3, 'chave: pedidos fora do recorte',
         CAST(COUNT(*) FILTER (WHERE id_pedido NOT IN (SELECT id_pedido FROM recorte)) AS VARCHAR)
  FROM versoes GROUP BY versao
  UNION ALL
  SELECT versao, 4, 'total: faturamento', CAST(ROUND(SUM(valor_itens), 2) AS DECIMAL(12, 2))::VARCHAR
  FROM versoes GROUP BY versao
  UNION ALL
  SELECT versao, 5, 'total: frete faturado', CAST(ROUND(SUM(frete), 2) AS DECIMAL(12, 2))::VARCHAR
  FROM versoes GROUP BY versao
  UNION ALL
  SELECT versao, 6, 'total: recebido', CAST(ROUND(SUM(recebido), 2) AS DECIMAL(12, 2))::VARCHAR
  FROM versoes GROUP BY versao
  UNION ALL
  SELECT versao, 7, 'total: a receber', CAST(ROUND(SUM(valor_itens - recebido), 2) AS DECIMAL(12, 2))::VARCHAR
  FROM versoes GROUP BY versao
  UNION ALL
  SELECT versao, 8, 'vazio: entregas sem fatura', CAST(SUM(entregas_sem_fatura) AS VARCHAR)
  FROM versoes GROUP BY versao
  UNION ALL
  SELECT versao, 9, 'vazio: pedidos com a receber vazio',
         CAST(COUNT(*) FILTER (WHERE valor_itens - recebido IS NULL) AS VARCHAR)
  FROM versoes GROUP BY versao
  UNION ALL
  SELECT versao, 10, 'fronteira: pedidos de 20/06',
         CAST(COUNT(*) FILTER (WHERE id_pedido IN (SELECT id_pedido FROM pedidos
              WHERE CAST(data_hora_pedido AS DATE) = DATE '2026-06-20')) AS VARCHAR)
  FROM versoes GROUP BY versao
  UNION ALL
  SELECT versao, 11, 'fronteira: pedidos de 31/05',
         CAST(COUNT(*) FILTER (WHERE id_pedido IN (SELECT id_pedido FROM pedidos
              WHERE CAST(data_hora_pedido AS DATE) = DATE '2026-05-31')) AS VARCHAR)
  FROM versoes GROUP BY versao
),
-- O esperado de cada teste, tirado das tabelas, cada uma somada sozinha.
esperado(n, valor) AS (
  SELECT 1, '0' UNION ALL
  SELECT 2, '0' UNION ALL
  SELECT 3, '0' UNION ALL
  SELECT 4, (SELECT CAST(ROUND(SUM(quantidade * preco_unitario - COALESCE(desconto, 0)), 2) AS DECIMAL(12, 2))::VARCHAR
             FROM itens_pedido WHERE id_pedido IN (SELECT id_pedido FROM recorte)) UNION ALL
  SELECT 5, (SELECT CAST(ROUND(SUM(custo_frete), 2) AS DECIMAL(12, 2))::VARCHAR
             FROM entregas WHERE id_pedido IN (SELECT id_pedido FROM recorte)) UNION ALL
  SELECT 6, (SELECT CAST(ROUND(SUM(valor), 2) AS DECIMAL(12, 2))::VARCHAR
             FROM pagamentos WHERE status = 'aprovado' AND id_pedido IN (SELECT id_pedido FROM recorte)) UNION ALL
  SELECT 7, (SELECT CAST(ROUND(
               (SELECT SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) FROM itens_pedido
                 WHERE id_pedido IN (SELECT id_pedido FROM recorte))
             - (SELECT SUM(valor) FROM pagamentos
                 WHERE status = 'aprovado' AND id_pedido IN (SELECT id_pedido FROM recorte)), 2) AS DECIMAL(12, 2))::VARCHAR) UNION ALL
  SELECT 8, (SELECT CAST(COUNT(*) AS VARCHAR) FROM entregas
             WHERE custo_frete IS NULL AND id_pedido IN (SELECT id_pedido FROM recorte)) UNION ALL
  SELECT 9, '0' UNION ALL
  SELECT 10, (SELECT CAST(COUNT(*) AS VARCHAR) FROM pedidos
              WHERE status <> 'cancelado' AND CAST(data_hora_pedido AS DATE) = DATE '2026-06-20') UNION ALL
  SELECT 11, '0'
),
tabela AS (
  SELECT t.n, t.teste, e.valor AS esperado,
         MAX(t.valor) FILTER (WHERE t.versao = 'diego') AS diego,
         MAX(t.valor) FILTER (WHERE t.versao = 'revisada') AS revisada
  FROM testes t JOIN esperado e USING (n)
  GROUP BY t.n, t.teste, e.valor
)
SELECT teste, esperado, COALESCE(diego, 'NULL') AS diego, revisada FROM (
  SELECT n, teste, esperado, diego, revisada FROM tabela
  UNION ALL
  SELECT 99, 'testes que passaram', CAST(COUNT(*) AS VARCHAR),
         CAST(COUNT(*) FILTER (WHERE diego IS NOT DISTINCT FROM esperado) AS VARCHAR),
         CAST(COUNT(*) FILTER (WHERE revisada IS NOT DISTINCT FROM esperado) AS VARCHAR)
  FROM tabela
)
ORDER BY n
