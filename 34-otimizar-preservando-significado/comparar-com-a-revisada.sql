-- A mesma prova para a versão revisada: mesmas linhas, nenhuma só de um lado.
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
), revisada AS (
    WITH por_pedido AS (
        SELECT id_pedido, canal, SUM(valor) AS valor_pedido
        FROM hist.itens_historico
        WHERE data_hora_pedido >= TIMESTAMP '2026-05-01 00:00:00'
          AND data_hora_pedido <  TIMESTAMP '2026-06-01 00:00:00'
        GROUP BY id_pedido, canal
    )
    SELECT canal, COUNT(*) AS pedidos, SUM(valor_pedido) AS vendido, ROUND(AVG(valor_pedido), 2) AS ticket_medio
    FROM por_pedido
    GROUP BY canal
), so_caio AS (
    SELECT * FROM caio EXCEPT ALL SELECT * FROM revisada
), so_revisada AS (
    SELECT * FROM revisada EXCEPT ALL SELECT * FROM caio
)
SELECT 'linhas na do Caio' AS conta, COUNT(*) AS n FROM caio
UNION ALL SELECT 'linhas na revisada', COUNT(*) FROM revisada
UNION ALL SELECT 'só na do Caio', COUNT(*) FROM so_caio
UNION ALL SELECT 'só na revisada', COUNT(*) FROM so_revisada;
