-- O pedido 687 passando pelas três primeiras etapas.
-- Rodar depois das etapas: python3 projeto.py etapas.sql pedido-nas-etapas.sql
-- Troque o 687 por outro pedido para seguir o caminho dele.
SELECT 1 AS etapa_n, 'cobrancas' AS etapa,
       'volume ' || volume || ', tentativa ' || tentativa || ', ' || tipo AS linha,
       parte AS detalhe, ROUND(custo_frete, 4) AS valor
FROM cobrancas WHERE id_pedido = 687
UNION ALL
SELECT 2, 'frete_por_pedido', 'pedido ' || id_pedido,
       'entrega ' || entrega || ' + falhou ' || falhou || ' + devolução ' || devolucao, ROUND(frete, 4)
FROM frete_por_pedido WHERE id_pedido = 687
UNION ALL
SELECT 3, 'rateio_por_item', 'item ' || n_item,
       categoria || ', ' || ROUND(100 * participacao, 2) || '% do valor', ROUND(parte_do_frete, 4)
FROM rateio_por_item WHERE id_pedido = 687
ORDER BY etapa_n, linha;
