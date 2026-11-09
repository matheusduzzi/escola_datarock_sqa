-- A consulta do Caio: pedidos por mês e categoria, de qualquer status.
-- Um pedido com itens de duas categorias conta nas duas.
-- A última parte junta as linhas de cada categoria numa linha só, para caber na tela.
WITH caio AS (
  SELECT strftime(p.data_hora_pedido, '%Y-%m') AS mes,
         d.categoria,
         COUNT(DISTINCT p.id_pedido) AS pedidos
  FROM pedidos p
  JOIN itens_pedido i USING (id_pedido)
  JOIN produtos d USING (id_produto)
  GROUP BY mes, d.categoria
)
SELECT categoria,
       COUNT(*) AS linhas,
       string_agg(mes || '=' || pedidos, ', ' ORDER BY mes) AS pedidos_por_mes
FROM caio
GROUP BY categoria
ORDER BY categoria;
