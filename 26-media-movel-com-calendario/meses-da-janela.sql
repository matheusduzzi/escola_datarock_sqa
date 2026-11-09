-- A mesma janela do Caio, em Esporte: para cada linha, o primeiro e o último mês
-- que entraram na conta e quantas linhas a janela pegou.
WITH fatos AS (
  SELECT CAST(date_trunc('month', p.data_hora_pedido) AS DATE) AS mes,
         d.categoria,
         COUNT(DISTINCT p.id_pedido) AS pedidos
  FROM pedidos p
  JOIN itens_pedido i USING (id_pedido)
  JOIN produtos d USING (id_produto)
  GROUP BY 1, 2
)
SELECT strftime(mes, '%Y-%m') AS mes,
       strftime(MIN(mes) OVER w, '%Y-%m') AS janela_de,
       strftime(MAX(mes) OVER w, '%Y-%m') AS janela_ate,
       COUNT(*) OVER w AS linhas_na_janela,
       date_diff('month', MIN(mes) OVER w, mes) + 1 AS meses_no_calendario
FROM fatos
WHERE categoria = 'Esporte'
WINDOW w AS (PARTITION BY categoria ORDER BY mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
ORDER BY mes;
