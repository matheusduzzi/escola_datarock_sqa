-- O que o DuckDB do kit retorna quando a conta divide por zero.
SELECT 47 / 0 AS quarenta_e_sete_por_zero,
       0 / 0 AS zero_por_zero,
       47 / NULLIF(0, 0) AS com_nullif,
       (47 - 0) / NULLIF(0, 0) AS diferenca_com_nullif;
