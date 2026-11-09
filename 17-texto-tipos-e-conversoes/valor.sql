-- Os valores com milhar e o valor vazio, nas duas conversões.
CREATE VIEW extrato AS
SELECT * FROM read_csv('dados/extrato_pix_marco.csv', header = true, all_varchar = true);

SELECT transacao,
       '[' || coalesce(valor, '') || ']'                          AS valor_no_arquivo,
       TRY_CAST(replace(valor, ',', '.') AS DECIMAL(10, 2))       AS so_troca_virgula,
       CASE WHEN regexp_full_match(trim(valor), '[0-9]{1,3}(\.[0-9]{3})*,[0-9]{2}')
            THEN CAST(replace(replace(trim(valor), '.', ''), ',', '.') AS DECIMAL(10, 2))
       END                                                        AS regra_da_aula
FROM extrato
WHERE valor LIKE '%.%,%' OR valor IS NULL
ORDER BY transacao;
