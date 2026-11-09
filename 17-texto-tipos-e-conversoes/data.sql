-- A data do extrato no formato dia/mês/ano: quantas convertem e quais não.
CREATE VIEW extrato AS
SELECT * FROM read_csv('dados/extrato_pix_marco.csv', header = true, all_varchar = true);

SELECT transacao,
       data                                                  AS data_no_arquivo,
       CAST(try_strptime(trim(data), '%d/%m/%Y') AS DATE)    AS data_pix,
       TRY_CAST(data AS DATE)                                AS try_cast_date
FROM extrato
WHERE try_strptime(trim(data), '%d/%m/%Y') IS NULL
   OR transacao IN ('PIX0001', 'PIX0073');
