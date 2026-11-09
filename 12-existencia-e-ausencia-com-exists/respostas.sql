-- As respostas da pesquisa de entrega de maio, como a ferramenta exportou. É o arquivo do exercício.
SELECT *
FROM read_csv('dados/respostas_pesquisa.csv', header = true)
ORDER BY data_resposta;
