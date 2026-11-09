-- O arquivo de itens como chegou do sistema da loja.
-- all_varchar = true lê toda coluna como texto; filename = true guarda de que arquivo veio cada linha.
CREATE VIEW bruto_itens AS
SELECT * FROM read_csv('../dados/itens_pedido.csv', all_varchar = true, filename = true);

SELECT
    COUNT(*)                                     AS linhas,
    typeof(MAX(preco_unitario))                  AS tipo,
    MAX(preco_unitario)                          AS maior_como_texto,
    MAX(CAST(preco_unitario AS DECIMAL(10, 2)))  AS maior_como_numero,
    MIN(preco_unitario)                          AS menor_como_texto,
    MIN(CAST(preco_unitario AS DECIMAL(10, 2)))  AS menor_como_numero,
    MIN(filename)                                AS arquivo
FROM bruto_itens;
