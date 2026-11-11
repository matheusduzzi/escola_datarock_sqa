-- A mesma série do Caio, com o mês da linha de cima (LAG) e o da linha de baixo (LEAD)
-- e a distância em meses entre cada linha e a de cima. Mostra só Esporte.
WITH por_mes AS (
  SELECT CAST(date_trunc('month', p.data_hora_pedido) AS DATE) AS mes,
         d.categoria,
         COUNT(DISTINCT p.id_pedido) AS pedidos
  FROM pedidos p
  JOIN itens_pedido i USING (id_pedido)
  JOIN produtos d USING (id_produto)
  GROUP BY 1, 2
),
vizinhos AS (
  SELECT mes, categoria, pedidos,
         LAG(mes) OVER (PARTITION BY categoria ORDER BY mes) AS mes_de_cima,
         LEAD(mes) OVER (PARTITION BY categoria ORDER BY mes) AS mes_de_baixo
  FROM por_mes
)
SELECT strftime(mes, '%Y-%m') AS mes,
       pedidos,
       strftime(mes_de_cima, '%Y-%m') AS linha_de_cima,
       strftime(mes_de_baixo, '%Y-%m') AS linha_de_baixo,
       date_diff('month', mes_de_cima, mes) AS meses_desde_a_de_cima
FROM vizinhos
WHERE categoria = 'Esporte'
ORDER BY mes;
