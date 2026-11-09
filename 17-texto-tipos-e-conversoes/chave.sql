-- A chave antes e depois da regra: espaço, caixa, prefixo e zeros à esquerda.
CREATE VIEW extrato AS
SELECT * FROM read_csv('dados/extrato_pix_marco.csv', header = true, all_varchar = true);

WITH limpo AS (
    SELECT transacao, pedido,
           regexp_replace(upper(trim(coalesce(pedido, ''))), '^PED[- ]?', '') AS pedido_limpo
    FROM extrato
)
SELECT transacao,
       '[' || coalesce(pedido, '') || ']'                         AS pedido_no_arquivo,
       '[' || pedido_limpo || ']'                                 AS pedido_limpo,
       CASE WHEN regexp_full_match(pedido_limpo, '[0-9]{1,9}')
            THEN CAST(pedido_limpo AS INTEGER) END                AS id_pedido
FROM limpo
WHERE coalesce(pedido, '') <> pedido_limpo
   OR NOT regexp_full_match(pedido_limpo, '[0-9]{1,9}')
   OR pedido_limpo LIKE '0%'
ORDER BY transacao;
