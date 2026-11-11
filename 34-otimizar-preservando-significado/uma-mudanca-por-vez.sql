-- As mudanças da IA, uma de cada vez, sobre a consulta do Caio. Cada linha compara uma versão com a do Caio.
-- A última linha é a troca do filtro feita do jeito certo, com >= e <.
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
), m_between AS (
    WITH por_pedido AS (
        SELECT id_pedido, canal, SUM(valor) AS valor_pedido
        FROM hist.itens_historico
        WHERE data_hora_pedido BETWEEN '2026-05-01' AND '2026-05-31'
        GROUP BY id_pedido, canal
    )
    SELECT canal, COUNT(*) AS pedidos, SUM(valor_pedido) AS vendido, ROUND(AVG(valor_pedido), 2) AS ticket_medio
    FROM por_pedido
    GROUP BY canal
), m_approx AS (
    WITH por_pedido AS (
        SELECT id_pedido, canal, SUM(valor) AS valor_pedido
        FROM hist.itens_historico
        WHERE strftime(data_hora_pedido, '%Y-%m') = '2026-05'
        GROUP BY id_pedido, canal
    )
    SELECT canal, approx_count_distinct(id_pedido) AS pedidos, SUM(valor_pedido) AS vendido,
           ROUND(AVG(valor_pedido), 2) AS ticket_medio
    FROM por_pedido
    GROUP BY canal
), m_sem_cte AS (
    SELECT canal, COUNT(DISTINCT id_pedido) AS pedidos, SUM(valor) AS vendido,
           ROUND(SUM(valor) / COUNT(DISTINCT id_pedido), 2) AS ticket_medio
    FROM hist.itens_historico
    WHERE strftime(data_hora_pedido, '%Y-%m') = '2026-05'
    GROUP BY canal
), m_faixa AS (
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
)
SELECT 1 AS n, 'filtro com BETWEEN e texto' AS mudanca,
       (SELECT COUNT(*) FROM m_between) AS linhas,
       (SELECT COUNT(*) FROM (SELECT * FROM caio EXCEPT ALL SELECT * FROM m_between)) AS so_no_caio,
       (SELECT COUNT(*) FROM (SELECT * FROM m_between EXCEPT ALL SELECT * FROM caio)) AS so_na_mudanca
UNION ALL
SELECT 2, 'approx_count_distinct nos pedidos', (SELECT COUNT(*) FROM m_approx),
       (SELECT COUNT(*) FROM (SELECT * FROM caio EXCEPT ALL SELECT * FROM m_approx)),
       (SELECT COUNT(*) FROM (SELECT * FROM m_approx EXCEPT ALL SELECT * FROM caio))
UNION ALL
SELECT 3, 'sem a CTE, com COUNT(DISTINCT)', (SELECT COUNT(*) FROM m_sem_cte),
       (SELECT COUNT(*) FROM (SELECT * FROM caio EXCEPT ALL SELECT * FROM m_sem_cte)),
       (SELECT COUNT(*) FROM (SELECT * FROM m_sem_cte EXCEPT ALL SELECT * FROM caio))
UNION ALL
SELECT 4, 'filtro com >= e <', (SELECT COUNT(*) FROM m_faixa),
       (SELECT COUNT(*) FROM (SELECT * FROM caio EXCEPT ALL SELECT * FROM m_faixa)),
       (SELECT COUNT(*) FROM (SELECT * FROM m_faixa EXCEPT ALL SELECT * FROM caio))
ORDER BY n;
