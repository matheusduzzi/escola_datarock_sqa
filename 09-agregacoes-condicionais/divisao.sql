-- A taxa de devolução de Eletro (21 de 266) com divisão inteira e com divisão decimal.
-- No DuckDB, // é a divisão inteira e / é a decimal.
SELECT 100 * 21 // 266          AS divisao_inteira,
       ROUND(100 * 21 / 266, 1) AS divisao_decimal;
