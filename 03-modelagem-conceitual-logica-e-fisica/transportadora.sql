-- A transportadora é do volume ou de cada tentativa?
-- Conta as linhas de entregas, as viagens de volume (pedido, tipo e volume)
-- e quantos volumes tiveram mais de uma transportadora.
SELECT
    SUM(linhas) AS linhas,
    COUNT(*) AS volumes,
    COUNT(*) FILTER (WHERE transportadoras > 1) AS volumes_com_duas
FROM (
    SELECT id_pedido, tipo, volume,
           COUNT(*) AS linhas,
           COUNT(DISTINCT transportadora) AS transportadoras
    FROM entregas
    GROUP BY id_pedido, tipo, volume
);
