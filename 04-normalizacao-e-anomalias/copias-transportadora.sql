-- Quantas vezes a transportadora de um volume aparece escrita em entregas, na base.
SELECT COUNT(*) AS linhas,
       COUNT(DISTINCT (id_pedido, tipo, volume)) AS volumes,
       COUNT(*) - COUNT(DISTINCT (id_pedido, tipo, volume)) AS copias_a_mais
FROM read_csv_auto('../dados/entregas.csv', header = true);
