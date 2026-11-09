-- Os pedidos do cliente 115 com a cidade do cadastro e a cidade que valia no dia do pedido.
CREATE VIEW historico_endereco AS SELECT * FROM read_csv('dados/historico_endereco.csv', header = true);

SELECT p.id_pedido,
       CAST(p.data_hora_pedido AS DATE) AS dia,
       p.status,
       c.cidade || '/' || c.uf          AS no_cadastro,
       h.cidade || '/' || h.uf          AS no_dia_do_pedido
FROM pedidos p
JOIN clientes c USING (id_cliente)
JOIN historico_endereco h
  ON h.id_cliente = p.id_cliente
 AND h.valido_de <= CAST(p.data_hora_pedido AS DATE)
 AND (h.valido_ate IS NULL OR CAST(p.data_hora_pedido AS DATE) < h.valido_ate)
WHERE p.id_cliente = 115
ORDER BY p.data_hora_pedido;
