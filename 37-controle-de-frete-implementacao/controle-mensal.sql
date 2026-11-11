-- O controle mensal da Marta: métricas 1 a 4 por mês do pedido e transportadora.
-- Rodar depois das etapas: python3 projeto.py etapas.sql controle-mensal.sql
-- Arredonda só aqui, na saída.
SELECT strftime(mes, '%Y-%m')            AS mes,
       transportadora,
       pedidos,
       ROUND(frete, 2)                   AS frete,
       ROUND(por_pedido, 2)              AS por_pedido,
       ROUND(por_volume, 2)              AS por_volume,
       ROUND(pct_falhou, 1)              AS pct_falhou,
       ROUND(pct_devolucao, 1)           AS pct_devolucao,
       fechado,
       ROUND(variacao_por_pedido, 2)     AS variacao
FROM controle_mensal
ORDER BY mes, transportadora;
