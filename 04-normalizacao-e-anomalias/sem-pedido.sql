-- Clientes do cadastro da base que não aparecem na planilha.
-- Lê o cadastro direto do CSV da base compartilhada, em ../dados.
SELECT COUNT(*) AS clientes_fora, MIN(data_cadastro) AS primeiro_cadastro, MAX(data_cadastro) AS ultimo_cadastro
FROM read_csv_auto('../dados/clientes.csv', header = true)
WHERE id_cliente NOT IN (SELECT id_cliente FROM vendas_larga);
