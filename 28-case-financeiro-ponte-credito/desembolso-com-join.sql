-- A primeira versão do desembolso por mês: o mês vem de desembolsos, e o valor vem de contratos.
SELECT strftime(d.data_desembolso, '%Y-%m') AS mes,
       SUM(k.valor_contratado) AS desembolsado
FROM contratos k
JOIN desembolsos d USING (id_contrato)
GROUP BY mes
ORDER BY mes;
