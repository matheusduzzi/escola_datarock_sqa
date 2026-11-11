-- Tira da base as entregas da Rota Leve de pedidos de fevereiro, só nesta execução.
-- Os CSVs não mudam. Serve para ver o que a variação faz quando falta um mês.
-- Rodar ANTES das etapas: python3 projeto.py buraco-em-fevereiro.sql etapas.sql controle-mensal.sql
CREATE TABLE entregas_completas AS SELECT * FROM entregas;
CREATE OR REPLACE VIEW entregas AS
SELECT e.*
FROM entregas_completas e
JOIN pedidos p USING (id_pedido)
WHERE NOT (e.transportadora = 'Rota Leve'
           AND p.data_hora_pedido >= TIMESTAMP '2026-02-01 00:00:00'
           AND p.data_hora_pedido <  TIMESTAMP '2026-03-01 00:00:00');
SELECT transportadora, COUNT(*) AS linhas_de_fevereiro
FROM entregas JOIN pedidos USING (id_pedido)
WHERE data_hora_pedido >= TIMESTAMP '2026-02-01 00:00:00' AND data_hora_pedido < TIMESTAMP '2026-03-01 00:00:00'
GROUP BY transportadora ORDER BY transportadora;
