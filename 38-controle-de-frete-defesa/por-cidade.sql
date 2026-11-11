-- A diferença entre as transportadoras some quando se olha uma cidade de cada vez?
-- Rodar: python3 projeto.py etapas.sql por-cidade.sql
-- Pedidos de janeiro a maio, os meses fechados, pela cidade do cadastro do cliente.
-- A base não tem o endereço da entrega, o peso nem o tamanho da caixa.
SELECT c.uf,
       c.cidade,
       COUNT(*) FILTER (WHERE f.transportadora = 'TransVale')                         AS pedidos_tv,
       ROUND(AVG(f.frete) FILTER (WHERE f.transportadora = 'TransVale'), 2)          AS transvale,
       COUNT(*) FILTER (WHERE f.transportadora = 'Rota Leve')                         AS pedidos_rl,
       ROUND(AVG(f.frete) FILTER (WHERE f.transportadora = 'Rota Leve'), 2)          AS rota_leve,
       ROUND(AVG(f.frete) FILTER (WHERE f.transportadora = 'TransVale')
           - AVG(f.frete) FILTER (WHERE f.transportadora = 'Rota Leve'), 2)          AS diferenca
FROM frete_por_pedido f
JOIN pedidos p USING (id_pedido)
JOIN clientes c USING (id_cliente)
WHERE f.mes_pedido < DATE '2026-06-01'
GROUP BY c.uf, c.cidade
ORDER BY c.uf, c.cidade;
