-- Um relatório novo: o ticket médio de maio por canal, para a Lúcia.
-- Ele entra como mais uma view de consumo e lê a regra. Rode o montar.sql antes.
ATTACH 'loja.duckdb' AS loja;

-- consumo_ticket_canal
--   Lê: regra_pedido
--   Para: Lúcia, ticket médio por canal.
--   Uma linha por: mês do pedido e canal.
--   Chave: mes + canal.
--   Colunas: mes ('AAAA-MM'), canal, pedidos_vendidos, vendido (2 casas), ticket_medio (2 casas).
CREATE OR REPLACE VIEW loja.consumo_ticket_canal AS
SELECT strftime(mes, '%Y-%m') AS mes,
       canal,
       COUNT(*) AS pedidos_vendidos,
       ROUND(SUM(valor), 2) AS vendido,
       ROUND(AVG(valor), 2) AS ticket_medio
FROM loja.regra_pedido
WHERE conta_como_venda
GROUP BY mes, canal;

SELECT canal, pedidos_vendidos, vendido, ticket_medio
FROM (
    SELECT 1 AS ordem, canal, pedidos_vendidos, vendido, ticket_medio
    FROM loja.consumo_ticket_canal
    WHERE mes = '2026-05'
    UNION ALL
    SELECT 2, 'total de maio', SUM(pedidos_vendidos), SUM(vendido),
           ROUND(SUM(vendido) / SUM(pedidos_vendidos), 2)
    FROM loja.consumo_ticket_canal
    WHERE mes = '2026-05'
)
ORDER BY ordem, canal;
