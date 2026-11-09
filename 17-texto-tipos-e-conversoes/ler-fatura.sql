-- Exercício: lê a fatura da Rota Leve como texto e mostra as primeiras linhas.
CREATE VIEW fatura AS
SELECT * FROM read_csv('dados/fatura_rota_leve_abril.csv', header = true, all_varchar = true);

SELECT * FROM fatura LIMIT 5;
