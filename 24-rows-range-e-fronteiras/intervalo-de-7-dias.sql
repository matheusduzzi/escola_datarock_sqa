-- Segunda tentativa: RANGE com INTERVAL 7 DAYS PRECEDING, sobre uma linha por pedido.
-- janela_de e janela_ate mostram o primeiro e o último dia que entraram na conta.
-- Como todo pedido do mesmo dia recebe o mesmo número, a saída mostra uma linha por dia.
WITH p AS (
    SELECT id_pedido, CAST(data_hora_pedido AS DATE) AS dia
    FROM pedidos
    WHERE status <> 'cancelado'
),
janela AS (
    SELECT dia,
           MIN(dia)  OVER w AS janela_de,
           MAX(dia)  OVER w AS janela_ate,
           COUNT(*)  OVER w AS pedidos_na_janela
    FROM p
    WINDOW w AS (ORDER BY dia RANGE BETWEEN INTERVAL 7 DAYS PRECEDING AND CURRENT ROW)
)
SELECT DISTINCT dia, janela_de, janela_ate,
       janela_ate - janela_de + 1 AS dias_na_janela,
       pedidos_na_janela
FROM janela
WHERE dia BETWEEN DATE '2026-01-07' AND DATE '2026-01-10'
ORDER BY dia;
