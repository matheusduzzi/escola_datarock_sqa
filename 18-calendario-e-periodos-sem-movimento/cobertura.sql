-- De quando a quando cada coluna de data tem registro na base.
SELECT o_que, primeiro, ultimo
FROM (
  SELECT 1 AS ordem, 'pedidos (data_hora_pedido)' AS o_que,
         CAST(MIN(data_hora_pedido) AS DATE) AS primeiro, CAST(MAX(data_hora_pedido) AS DATE) AS ultimo
  FROM pedidos
  UNION ALL
  SELECT 2, 'tentativas de entrega (data_tentativa)', MIN(data_tentativa), MAX(data_tentativa)
  FROM entregas
  UNION ALL
  SELECT 3, 'tentativas com custo de frete', MIN(data_tentativa), MAX(data_tentativa)
  FROM entregas WHERE custo_frete IS NOT NULL
  UNION ALL
  SELECT 4, 'tentativas sem custo de frete', MIN(data_tentativa), MAX(data_tentativa)
  FROM entregas WHERE data_tentativa IS NOT NULL AND custo_frete IS NULL
)
ORDER BY ordem;
