-- A primeira tentativa: TRY_CAST na chave, vírgula trocada por ponto no valor e soma.
CREATE VIEW extrato AS
SELECT * FROM read_csv('dados/extrato_pix_marco.csv', header = true, all_varchar = true);

SELECT COUNT(*)                                                       AS linhas,
       COUNT(p.id_pedido)                                             AS achadas_na_loja,
       SUM(TRY_CAST(replace(e.valor, ',', '.') AS DECIMAL(10, 2)))    AS valor_somado,
       (SELECT SUM(CAST(valor AS DECIMAL(10, 2))) FROM pagamentos
         WHERE forma = 'pix' AND status = 'aprovado'
           AND data_hora_pagamento >= TIMESTAMP '2026-03-01'
           AND data_hora_pagamento <  TIMESTAMP '2026-04-01')         AS pix_da_loja
FROM extrato e
LEFT JOIN pagamentos p
       ON p.id_pedido = TRY_CAST(e.pedido AS INTEGER)
      AND p.forma = 'pix' AND p.status = 'aprovado';
