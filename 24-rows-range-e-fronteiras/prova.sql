-- A prova: cada versão da janela contra a conta sem janela, em todos os dias do semestre.
-- A conta sem janela soma os pedidos por dia e junta cada dia do calendário com os 6 anteriores.
WITH p AS (
    SELECT id_pedido, CAST(data_hora_pedido AS DATE) AS dia
    FROM pedidos
    WHERE status <> 'cancelado'
),
por_dia AS (
    SELECT dia, COUNT(*) AS pedidos FROM p GROUP BY dia
),
sem_janela AS (
    SELECT d.dia, SUM(o.pedidos) AS esperado
    FROM por_dia d
    JOIN por_dia o ON o.dia BETWEEN d.dia - INTERVAL 6 DAYS AND d.dia
    GROUP BY d.dia
),
janelas AS (
    SELECT id_pedido, dia,
           COUNT(*) OVER (ORDER BY dia, id_pedido ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS caio,
           COUNT(*) OVER (ORDER BY dia RANGE BETWEEN INTERVAL 7 DAYS PRECEDING AND CURRENT ROW) AS intervalo_7,
           COUNT(*) OVER (ORDER BY dia GROUPS BETWEEN 6 PRECEDING AND CURRENT ROW) AS groups_6,
           COUNT(*) OVER (ORDER BY dia RANGE BETWEEN INTERVAL 6 DAYS PRECEDING AND CURRENT ROW) AS certa
    FROM p
),
comparado AS (
    SELECT j.*, s.esperado FROM janelas j JOIN sem_janela s USING (dia)
)
SELECT 'dias com o número da conta sem janela' AS checagem,
       COUNT(*) AS esperado,
       COUNT(*) FILTER (WHERE certa) AS certa,
       COUNT(*) FILTER (WHERE caio) AS caio,
       COUNT(*) FILTER (WHERE intervalo_7) AS intervalo_7,
       COUNT(*) FILTER (WHERE groups_6) AS groups_6
FROM (SELECT dia, bool_and(certa = esperado) AS certa, bool_and(caio = esperado) AS caio,
             bool_and(intervalo_7 = esperado) AS intervalo_7, bool_and(groups_6 = esperado) AS groups_6
      FROM comparado GROUP BY dia)
UNION ALL
SELECT 'pedidos com o número da conta sem janela',
       COUNT(*),
       COUNT(*) FILTER (WHERE certa = esperado),
       COUNT(*) FILTER (WHERE caio = esperado),
       COUNT(*) FILTER (WHERE intervalo_7 = esperado),
       COUNT(*) FILTER (WHERE groups_6 = esperado)
FROM comparado;
