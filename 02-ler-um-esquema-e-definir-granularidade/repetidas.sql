-- Quais combinações de id_pedido + volume + tentativa aparecem mais de uma vez em entregas,
-- e com que tipos. Mostra as três primeiras e quantas são no total.
SELECT id_pedido, volume, tentativa,
       COUNT(*) AS linhas,
       STRING_AGG(tipo, ', ' ORDER BY tipo DESC) AS tipos,
       COUNT(*) OVER () AS combinacoes_repetidas
FROM entregas
GROUP BY id_pedido, volume, tentativa
HAVING COUNT(*) > 1
ORDER BY id_pedido
LIMIT 3;
