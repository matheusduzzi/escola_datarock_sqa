-- As linhas em que o TRY_CAST da primeira tentativa trocou o texto por NULL.
CREATE VIEW extrato AS
SELECT * FROM read_csv('dados/extrato_pix_marco.csv', header = true, all_varchar = true);

SELECT transacao,
       '[' || coalesce(pedido, '') || ']'                        AS pedido_no_arquivo,
       TRY_CAST(pedido AS INTEGER)                               AS pedido_try_cast,
       '[' || coalesce(valor, '') || ']'                         AS valor_no_arquivo,
       TRY_CAST(replace(valor, ',', '.') AS DECIMAL(10, 2))      AS valor_try_cast
FROM extrato
WHERE TRY_CAST(pedido AS INTEGER) IS NULL
   OR TRY_CAST(replace(valor, ',', '.') AS DECIMAL(10, 2)) IS NULL
ORDER BY transacao;
