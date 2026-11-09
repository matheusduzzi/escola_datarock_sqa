-- O pedido 200, do cliente 4, foi feito em 08/02/2026: o mesmo dia em que o cadastro dele mudou de Sorocaba para Campinas.
-- Três jeitos de achar a cidade que valia no dia do pedido.
CREATE VIEW historico_endereco AS SELECT * FROM read_csv('dados/historico_endereco.csv', header = true);

WITH pedido AS (
    SELECT id_cliente, CAST(data_hora_pedido AS DATE) AS dia FROM pedidos WHERE id_pedido = 200
)
SELECT 'começo entra, fim não entra' AS jeito, COUNT(h.cidade) AS linhas, string_agg(h.cidade, ', ') AS cidades
FROM pedido p
LEFT JOIN historico_endereco h
  ON h.id_cliente = p.id_cliente
 AND h.valido_de <= p.dia
 AND (h.valido_ate IS NULL OR p.dia < h.valido_ate)
UNION ALL
SELECT 'BETWEEN valido_de AND valido_ate', COUNT(h.cidade), string_agg(h.cidade, ', ')
FROM pedido p
LEFT JOIN historico_endereco h
  ON h.id_cliente = p.id_cliente
 AND p.dia BETWEEN h.valido_de AND h.valido_ate
UNION ALL
SELECT 'BETWEEN com fim vazio trocado por 9999-12-31', COUNT(h.cidade), string_agg(h.cidade, ', ')
FROM pedido p
LEFT JOIN historico_endereco h
  ON h.id_cliente = p.id_cliente
 AND p.dia BETWEEN h.valido_de AND COALESCE(h.valido_ate, DATE '9999-12-31');
