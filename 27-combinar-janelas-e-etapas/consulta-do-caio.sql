-- A consulta do Caio para a Marta: o resultado da última tentativa de entrega.
WITH numeradas AS (
    SELECT id_pedido, volume, tentativa, data_tentativa, resultado,
           ROW_NUMBER() OVER (PARTITION BY id_pedido
                              ORDER BY tentativa DESC, id_entrega DESC) AS ordem
    FROM entregas
    WHERE tipo = 'ida'
)
SELECT id_pedido, volume, tentativa, data_tentativa, resultado
FROM numeradas
WHERE ordem = 1
  AND resultado IS NOT NULL
ORDER BY id_pedido, volume;
