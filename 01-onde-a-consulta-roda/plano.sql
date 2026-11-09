-- Pergunta ao DuckDB quais colunas do Parquet ele vai ler para somar o frete por mês.
-- Rode depois de colunas.sql:  python3 consultar.py --arquivo plano.sql
EXPLAIN
SELECT date_trunc('month', data_tentativa) AS mes,
       SUM(custo_frete) AS frete
FROM 'entregas.parquet'
GROUP BY mes;
