-- Grava a tabela de entregas em Parquet e mostra quantos bytes cada coluna ocupa no arquivo.
-- Rode dentro da pasta da aula:  python3 consultar.py --dados ../dados --arquivo colunas.sql
-- O arquivo entregas.parquet aparece nesta pasta. Pode apagar depois: ele sai igual toda vez.
COPY (SELECT * FROM entregas ORDER BY id_entrega) TO 'entregas.parquet' (FORMAT parquet);

SELECT path_in_schema AS coluna,
       SUM(total_compressed_size) AS bytes
FROM parquet_metadata('entregas.parquet')
GROUP BY coluna
ORDER BY bytes DESC;
