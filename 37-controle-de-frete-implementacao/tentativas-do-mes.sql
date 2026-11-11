-- Métrica 5: o frete das tentativas feitas em cada mês, para bater com a fatura da transportadora.
-- Rodar depois das etapas: python3 projeto.py etapas.sql tentativas-do-mes.sql
SELECT strftime(mes, '%Y-%m')   AS mes,
       transportadora,
       linhas,
       ROUND(frete, 2)          AS frete,
       linhas_sem_fatura
FROM tentativas_do_mes
WHERE mes >= DATE '2026-04-01'
ORDER BY mes, transportadora;
