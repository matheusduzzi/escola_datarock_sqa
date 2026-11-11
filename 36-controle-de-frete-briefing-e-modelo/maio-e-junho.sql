-- O mesmo cálculo para maio e para junho, pelo mês do pedido.
-- Junho vai até o dia 20: há fatura que não chegou e volume que ainda está na rua.
WITH linhas AS (
    SELECT strftime(p.data_hora_pedido, '%Y-%m') AS mes, e.*
    FROM entregas e
    JOIN pedidos p USING (id_pedido)
    WHERE p.data_hora_pedido >= TIMESTAMP '2026-05-01 00:00:00'
      AND p.status <> 'cancelado'
)
SELECT mes,
       COUNT(DISTINCT id_pedido) AS pedidos,
       COUNT(*) FILTER (WHERE tipo = 'ida' AND resultado = 'entregue') AS volumes_entregues,
       ROUND(SUM(custo_frete), 2) AS frete,
       ROUND(SUM(custo_frete) / COUNT(DISTINCT id_pedido), 2) AS por_pedido,
       ROUND(SUM(custo_frete) / COUNT(*) FILTER (WHERE tipo = 'ida' AND resultado = 'entregue'), 2) AS por_volume,
       COUNT(*) - COUNT(custo_frete) AS linhas_sem_fatura,
       COUNT(*) FILTER (WHERE tipo = 'ida' AND resultado IS NULL) AS volumes_na_rua
FROM linhas
GROUP BY mes
ORDER BY mes;
