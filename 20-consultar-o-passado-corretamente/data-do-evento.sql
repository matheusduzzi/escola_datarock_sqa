-- Os volumes em que a cidade do dia do pedido e a cidade do dia da saída do volume são diferentes.
-- O mesmo histórico, buscado por duas datas do mesmo pedido.
CREATE VIEW historico_endereco AS SELECT * FROM read_csv('dados/historico_endereco.csv', header = true);

SELECT e.id_entrega, e.id_pedido, p.id_cliente, e.tipo,
       CAST(p.data_hora_pedido AS DATE) AS dia_do_pedido,
       hp.cidade AS cidade_no_pedido,
       e.data_saida AS dia_da_saida,
       hs.cidade AS cidade_na_saida,
       e.custo_frete
FROM entregas e
JOIN pedidos p USING (id_pedido)
JOIN historico_endereco hp
  ON hp.id_cliente = p.id_cliente
 AND hp.valido_de <= CAST(p.data_hora_pedido AS DATE)
 AND (hp.valido_ate IS NULL OR CAST(p.data_hora_pedido AS DATE) < hp.valido_ate)
JOIN historico_endereco hs
  ON hs.id_cliente = p.id_cliente
 AND hs.valido_de <= e.data_saida
 AND (hs.valido_ate IS NULL OR e.data_saida < hs.valido_ate)
WHERE hp.cidade <> hs.cidade
ORDER BY e.id_entrega;
