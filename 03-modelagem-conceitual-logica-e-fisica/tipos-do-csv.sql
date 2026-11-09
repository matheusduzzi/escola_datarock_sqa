-- Que tipo o DuckDB escolheu para o preço ao ler o CSV, e o que isso faz com a soma.
-- A primeira soma usa o tipo que veio do CSV (DOUBLE).
-- A segunda converte para DECIMAL(10,2): dez dígitos, dois depois da vírgula.
SELECT
    ANY_VALUE(typeof(preco_unitario)) AS tipo_no_csv,
    SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS soma_double,
    SUM(quantidade * CAST(preco_unitario AS DECIMAL(10, 2))
        - COALESCE(CAST(desconto AS DECIMAL(10, 2)), 0)) AS soma_decimal
FROM itens_pedido;
