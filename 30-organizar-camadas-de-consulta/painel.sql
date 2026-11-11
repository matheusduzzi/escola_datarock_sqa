-- O painel da Lúcia lido da camada de consumo. Rode o montar.sql antes.
ATTACH 'loja.duckdb' AS loja (READ_ONLY);

SELECT * FROM loja.consumo_painel_mes;
