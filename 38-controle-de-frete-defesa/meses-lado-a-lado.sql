-- Custo por pedido das duas transportadoras em cada mês fechado, a diferença entre elas e os cinco meses juntos.
-- Rodar: python3 projeto.py etapas.sql meses-lado-a-lado.sql
-- Só meses fechados: o mesmo filtro que o contrato usa para comparar meses.
-- A linha "jan a mai" soma o frete e os pedidos dos cinco meses antes de dividir.
WITH fechados AS (
    SELECT * FROM controle_mensal WHERE fechado
),
por_mes AS (
    SELECT 1 AS ordem, strftime(mes, '%Y-%m') AS mes, transportadora, pedidos, frete, falhou,
           frete - falhou - devolucao AS entrega
    FROM fechados
    UNION ALL
    SELECT 2, 'jan a mai', transportadora, SUM(pedidos), SUM(frete), SUM(falhou), SUM(frete - falhou - devolucao)
    FROM fechados
    GROUP BY transportadora
)
SELECT t.mes,
       t.pedidos                                              AS pedidos_transvale,
       ROUND(t.frete / t.pedidos, 2)                          AS transvale,
       r.pedidos                                              AS pedidos_rota_leve,
       ROUND(r.frete / r.pedidos, 2)                          AS rota_leve,
       ROUND(t.frete / t.pedidos - r.frete / r.pedidos, 2)    AS diferenca,
       ROUND(100 * t.falhou / t.entrega, 1)                   AS falhou_pct_entrega_tv,
       ROUND(100 * r.falhou / r.entrega, 1)                   AS falhou_pct_entrega_rl
FROM por_mes t
JOIN por_mes r ON r.ordem = t.ordem AND r.mes = t.mes AND r.transportadora = 'Rota Leve'
WHERE t.transportadora = 'TransVale'
ORDER BY t.ordem, t.mes;
