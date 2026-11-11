-- Pedidos de cada dia, de 1º a 21 de janeiro. Pedido cancelado fica de fora.
-- É a tabela de partida da aula: a conta sem janela.
SELECT CAST(data_hora_pedido AS DATE) AS dia,
       COUNT(*) AS pedidos
FROM pedidos
WHERE status <> 'cancelado'
  AND data_hora_pedido < DATE '2026-01-22'
GROUP BY 1
ORDER BY 1;
