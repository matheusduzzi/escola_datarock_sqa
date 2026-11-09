-- Os tipos que o DuckDB escolhe sozinho quando lê o extrato do banco.
DESCRIBE SELECT * FROM read_csv('dados/extrato_pix_marco.csv', header = true);
