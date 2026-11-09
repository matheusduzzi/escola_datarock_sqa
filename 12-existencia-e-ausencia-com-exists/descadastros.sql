-- A lista de descadastro que a ferramenta de e-mail exportou, como chegou.
SELECT *
FROM read_csv('dados/descadastros.csv', header = true)
ORDER BY data_descadastro;
