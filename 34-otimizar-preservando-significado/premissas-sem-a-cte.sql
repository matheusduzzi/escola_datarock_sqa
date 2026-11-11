-- As duas premissas de que a consulta sem a CTE precisa, contadas no histórico: nenhum item sem id_pedido
-- e nenhum item sem valor. Se as duas derem 0, as duas consultas retornam o mesmo nesses dados.
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
SELECT COUNT(*) - COUNT(id_pedido) AS itens_sem_id_pedido,
       COUNT(*) - COUNT(valor) AS itens_sem_valor
FROM hist.itens_historico;
