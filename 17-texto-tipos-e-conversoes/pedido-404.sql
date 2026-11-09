-- Pedido 2 da prática: a linha com letra no pedido e o Pix do pedido 404 na loja.
CREATE VIEW extrato AS
SELECT * FROM read_csv('dados/extrato_pix_marco.csv', header = true, all_varchar = true);

-- Os Pix aprovados de março na tabela pagamentos da loja.
CREATE VIEW pix_loja AS
SELECT id_pedido, CAST(data_hora_pagamento AS DATE) AS data_pix, CAST(valor AS DECIMAL(10, 2)) AS valor
FROM pagamentos
WHERE forma = 'pix' AND status = 'aprovado'
  AND data_hora_pagamento >= TIMESTAMP '2026-03-01' AND data_hora_pagamento < TIMESTAMP '2026-04-01';

SELECT 'extrato' AS origem, data AS data_pix, pedido, valor
FROM extrato WHERE transacao = 'PIX0048'
UNION ALL
SELECT 'loja', strftime(data_pix, '%d/%m/%Y'), CAST(id_pedido AS VARCHAR), CAST(valor AS VARCHAR)
FROM pix_loja WHERE id_pedido = 404;
