-- Na base, a transportadora vai escrita em cada tentativa de entrega.
-- Esta consulta lista os volumes em que as linhas discordam sobre a transportadora.
-- Saída vazia quer dizer que, hoje, todas as cópias concordam.
SELECT id_pedido, tipo, volume, STRING_AGG(DISTINCT transportadora, ', ') AS transportadoras, COUNT(*) AS linhas
FROM read_csv_auto('../dados/entregas.csv', header = true)
GROUP BY id_pedido, tipo, volume
HAVING COUNT(DISTINCT transportadora) > 1;
