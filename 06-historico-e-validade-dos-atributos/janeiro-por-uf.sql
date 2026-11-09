-- Vendas de janeiro de 2026 (pedidos entregues) por UF, de dois jeitos:
-- pela UF do cadastro de hoje e pela UF que valia no dia do pedido.
CREATE VIEW historico_endereco AS SELECT * FROM read_csv('dados/historico_endereco.csv', header = true);

WITH valor_pedido AS (
    SELECT id_pedido, SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS valor
    FROM itens_pedido
    GROUP BY id_pedido
),
janeiro AS (
    SELECT p.id_pedido, p.id_cliente, CAST(p.data_hora_pedido AS DATE) AS dia, v.valor
    FROM pedidos p
    JOIN valor_pedido v USING (id_pedido)
    WHERE p.status = 'entregue'
      AND p.data_hora_pedido >= TIMESTAMP '2026-01-01'
      AND p.data_hora_pedido <  TIMESTAMP '2026-02-01'
),
com_uf AS (
    SELECT j.*, c.uf AS uf_cadastro, h.uf AS uf_no_dia
    FROM janeiro j
    JOIN clientes c USING (id_cliente)
    JOIN historico_endereco h
      ON h.id_cliente = j.id_cliente
     AND h.valido_de <= j.dia
     AND (h.valido_ate IS NULL OR j.dia < h.valido_ate)
)
SELECT u.uf,
       (SELECT ROUND(SUM(valor), 2) FROM com_uf WHERE uf_cadastro = u.uf) AS pelo_cadastro,
       (SELECT ROUND(SUM(valor), 2) FROM com_uf WHERE uf_no_dia = u.uf)   AS no_dia_do_pedido,
       (SELECT COUNT(*) FROM com_uf)                                       AS pedidos,
       (SELECT ROUND(SUM(valor), 2) FROM com_uf)                           AS total
FROM (SELECT uf_cadastro AS uf FROM com_uf UNION SELECT uf_no_dia FROM com_uf) u
ORDER BY u.uf;
