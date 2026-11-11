-- Antes do tempo, o resultado: a versão da IA retorna as mesmas linhas que a do Caio?
-- Mostra as linhas que só uma das duas tem (EXCEPT ALL, nos dois sentidos). Sem diferença, a saída vem vazia.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
WITH caio AS (
    WITH por_pedido AS (
        SELECT id_pedido, canal, SUM(valor) AS valor_pedido
        FROM hist.itens_historico
        WHERE strftime(data_hora_pedido, '%Y-%m') = '2026-05'
        GROUP BY id_pedido, canal
    )
    SELECT canal, COUNT(*) AS pedidos, SUM(valor_pedido) AS vendido, ROUND(AVG(valor_pedido), 2) AS ticket_medio
    FROM por_pedido
    GROUP BY canal
), ia AS (
    SELECT canal,
           approx_count_distinct(id_pedido) AS pedidos,
           SUM(valor) AS vendido,
           ROUND(SUM(valor) / approx_count_distinct(id_pedido), 2) AS ticket_medio
    FROM hist.itens_historico
    WHERE data_hora_pedido BETWEEN '2026-05-01' AND '2026-05-31'
    GROUP BY canal
), so_caio AS (
    SELECT * FROM caio EXCEPT ALL SELECT * FROM ia
), so_ia AS (
    SELECT * FROM ia EXCEPT ALL SELECT * FROM caio
)
SELECT lado, canal, pedidos, vendido, ticket_medio FROM (
    SELECT 1 AS ordem, 'só na do Caio' AS lado, * FROM so_caio
    UNION ALL
    SELECT 2, 'só na da IA', * FROM so_ia
)
ORDER BY ordem, canal;
