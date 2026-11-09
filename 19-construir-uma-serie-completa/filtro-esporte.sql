-- Só Esporte, com a tabela de meses e LEFT JOIN, em dois lugares para o filtro de categoria.
-- Versão 1: o filtro fica no WHERE, depois do LEFT JOIN.
-- Versão 2: o filtro fica na consulta dos fatos, antes do LEFT JOIN.
WITH meses AS (
  SELECT CAST(inicio AS DATE) AS mes
  FROM range(TIMESTAMP '2026-01-01', TIMESTAMP '2026-07-01', INTERVAL 1 MONTH) AS t(inicio)
),
fatos AS (
  SELECT CAST(date_trunc('month', p.data_hora_pedido) AS DATE) AS mes,
         d.categoria,
         COUNT(DISTINCT p.id_pedido) AS pedidos
  FROM pedidos p
  JOIN itens_pedido i USING (id_pedido)
  JOIN produtos d USING (id_produto)
  GROUP BY 1, 2
),
versao_1 AS (
  SELECT m.mes, COALESCE(f.pedidos, 0) AS pedidos
  FROM meses m
  LEFT JOIN fatos f ON f.mes = m.mes
  WHERE f.categoria = 'Esporte'
),
versao_2 AS (
  SELECT m.mes, COALESCE(f.pedidos, 0) AS pedidos
  FROM meses m
  LEFT JOIN (SELECT * FROM fatos WHERE categoria = 'Esporte') f ON f.mes = m.mes
)
SELECT 'filtro no WHERE' AS versao, COUNT(*) AS linhas,
       string_agg(strftime(mes, '%m') || '=' || pedidos, ', ' ORDER BY mes) AS pedidos_por_mes
FROM versao_1
UNION ALL
SELECT 'filtro antes do LEFT JOIN', COUNT(*),
       string_agg(strftime(mes, '%m') || '=' || pedidos, ', ' ORDER BY mes)
FROM versao_2;
