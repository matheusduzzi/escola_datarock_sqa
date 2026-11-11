-- Que fração da tabela cada pedido da aula leva? Seletividade = linhas que passam no filtro / linhas da tabela.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT 'pedido 1400000'   AS filtro, COUNT(*) FILTER (WHERE id_pedido = 1400000) AS linhas,
       COUNT(*) AS total, ROUND(100.0 * COUNT(*) FILTER (WHERE id_pedido = 1400000) / COUNT(*), 4) AS pct
FROM hist.itens_historico
UNION ALL
SELECT 'maio de 2026', COUNT(*) FILTER (WHERE data_hora_pedido >= TIMESTAMP '2026-05-01' AND data_hora_pedido < TIMESTAMP '2026-06-01'),
       COUNT(*), ROUND(100.0 * COUNT(*) FILTER (WHERE data_hora_pedido >= TIMESTAMP '2026-05-01' AND data_hora_pedido < TIMESTAMP '2026-06-01') / COUNT(*), 4)
FROM hist.itens_historico
UNION ALL
SELECT 'categoria Eletro', COUNT(*) FILTER (WHERE categoria = 'Eletro'),
       COUNT(*), ROUND(100.0 * COUNT(*) FILTER (WHERE categoria = 'Eletro') / COUNT(*), 4)
FROM hist.itens_historico;
