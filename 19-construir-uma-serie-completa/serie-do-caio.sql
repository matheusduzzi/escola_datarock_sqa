-- A segunda versão do Caio, depois da especificação da aula 18:
-- uma tabela de meses de janeiro a junho, com LEFT JOIN nos pedidos por mês e categoria
-- e COALESCE para pôr 0 onde não tem pedido.
-- A última parte junta as linhas de cada categoria numa linha só, para caber na tela.
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
serie AS (
  SELECT m.mes, f.categoria, COALESCE(f.pedidos, 0) AS pedidos
  FROM meses m
  LEFT JOIN fatos f ON f.mes = m.mes
)
SELECT categoria,
       COUNT(*) AS linhas,
       string_agg(strftime(mes, '%m') || '=' || pedidos, ', ' ORDER BY mes) AS pedidos_por_mes
FROM serie
GROUP BY categoria
ORDER BY categoria;
