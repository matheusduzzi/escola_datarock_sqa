-- De onde vem a diferença de custo por pedido entre TransVale e Rota Leve em maio.
-- Rodar: python3 projeto.py etapas.sql diferenca-entre-transportadoras.sql
-- O custo por pedido é a soma de três partes por pedido: entrega, tentativa que falhou e devolução.
-- A entrega por pedido ainda se abre em volumes por pedido vezes o preço de cada volume entregue.
WITH maio AS (
    SELECT transportadora,
           pedidos,
           volumes_entregues / pedidos                  AS volumes_por_pedido,
           (frete - falhou - devolucao) / volumes_entregues AS entrega_por_volume,
           (frete - falhou - devolucao) / pedidos       AS entrega,
           falhou / pedidos                             AS falhou,
           devolucao / pedidos                          AS devolucao,
           por_pedido
    FROM controle_mensal
    WHERE mes = DATE '2026-05-01'
),
lado_a_lado AS (
    SELECT 1 AS ordem, transportadora AS linha, pedidos, volumes_por_pedido, entrega_por_volume,
           entrega, falhou, devolucao, por_pedido
    FROM maio
    UNION ALL
    SELECT 2, 'diferença (TransVale - Rota Leve)', NULL,
           t.volumes_por_pedido - r.volumes_por_pedido, t.entrega_por_volume - r.entrega_por_volume,
           t.entrega - r.entrega, t.falhou - r.falhou, t.devolucao - r.devolucao, t.por_pedido - r.por_pedido
    FROM maio t, maio r
    WHERE t.transportadora = 'TransVale' AND r.transportadora = 'Rota Leve'
)
SELECT linha, pedidos,
       ROUND(volumes_por_pedido, 2) AS volumes_por_pedido,
       ROUND(entrega_por_volume, 2) AS entrega_por_volume,
       ROUND(entrega, 2)            AS entrega,
       ROUND(falhou, 2)             AS falhou,
       ROUND(devolucao, 2)          AS devolucao,
       ROUND(por_pedido, 2)         AS por_pedido
FROM lado_a_lado
ORDER BY ordem, linha;
