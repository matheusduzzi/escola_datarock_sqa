-- Pedido 3 da prática: o valor do pedido 400 nas três conversões, e o Pix dele na loja.
CREATE VIEW extrato AS
SELECT * FROM read_csv('dados/extrato_pix_marco.csv', header = true, all_varchar = true);

-- Os Pix aprovados de março na tabela pagamentos da loja.
CREATE VIEW pix_loja AS
SELECT id_pedido, CAST(data_hora_pagamento AS DATE) AS data_pix, CAST(valor AS DECIMAL(10, 2)) AS valor
FROM pagamentos
WHERE forma = 'pix' AND status = 'aprovado'
  AND data_hora_pagamento >= TIMESTAMP '2026-03-01' AND data_hora_pagamento < TIMESTAMP '2026-04-01';

SELECT e.valor                                                         AS valor_no_arquivo,
       TRY_CAST(replace(e.valor, ',', '.') AS DECIMAL(10, 2))          AS so_troca_virgula,
       TRY_CAST(replace(replace(e.valor, '.', ''), ',', '.') AS DECIMAL(10, 2)) AS tira_ponto_e_troca_virgula,
       CASE WHEN regexp_full_match(e.valor, '[0-9]{1,3}(\.[0-9]{3})*,[0-9]{2}')
            THEN CAST(replace(replace(e.valor, '.', ''), ',', '.') AS DECIMAL(10, 2)) END AS regra_da_aula,
       l.valor                                                         AS valor_na_loja
FROM extrato e
JOIN pix_loja l ON l.id_pedido = 400
WHERE e.transacao = 'PIX0046';
