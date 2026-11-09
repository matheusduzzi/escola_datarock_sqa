-- O que vira uma data sem hora quando ela é comparada com data e hora.
-- O pedido 160 foi feito em 31/01/2026 às 23:58:41.
SELECT CAST(DATE '2026-01-31' AS TIMESTAMP) AS ultimo_dia_vira,
       TIMESTAMP '2026-01-31 23:58:41' BETWEEN DATE '2026-01-01' AND DATE '2026-01-31' AS pedido_160_entra;
