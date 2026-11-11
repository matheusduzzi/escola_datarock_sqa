-- Esporte em maio e junho: pedidos no mês, dias que a base cobre e pedidos por dia coberto.
WITH dias AS (
  SELECT CAST(date_trunc('month', dia) AS DATE) AS mes, COUNT(*) AS dias_na_base
  FROM (SELECT DISTINCT CAST(t.d AS DATE) AS dia
        FROM (SELECT CAST(MIN(data_hora_pedido) AS DATE) AS a, CAST(MAX(data_hora_pedido) AS DATE) AS b FROM pedidos) l,
             range(l.a, l.b + 1, INTERVAL 1 DAY) AS t(d))
  GROUP BY 1
),
esporte AS (
  SELECT CAST(date_trunc('month', p.data_hora_pedido) AS DATE) AS mes,
         COUNT(DISTINCT p.id_pedido) AS pedidos
  FROM pedidos p
  JOIN itens_pedido i USING (id_pedido)
  JOIN produtos d USING (id_produto)
  WHERE d.categoria = 'Esporte'
  GROUP BY 1
)
SELECT strftime(e.mes, '%Y-%m') AS mes,
       e.pedidos,
       x.dias_na_base,
       ROUND(e.pedidos / x.dias_na_base, 2) AS pedidos_por_dia
FROM esporte e
JOIN dias x USING (mes)
WHERE e.mes >= DATE '2026-05-01'
ORDER BY e.mes;
