-- Tentativa de pôr o id_pedido na ordem de um RANGE com distância de 6 dias.
-- Dá erro de propósito: veja a mensagem.
WITH p AS (
    SELECT id_pedido, CAST(data_hora_pedido AS DATE) AS dia
    FROM pedidos
    WHERE status <> 'cancelado'
)
SELECT id_pedido, dia,
       COUNT(*) OVER (ORDER BY dia, id_pedido
                      RANGE BETWEEN INTERVAL 6 DAYS PRECEDING AND CURRENT ROW) AS pedidos_7_dias
FROM p
ORDER BY dia, id_pedido
LIMIT 5;
