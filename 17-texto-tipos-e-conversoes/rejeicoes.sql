-- As linhas rejeitadas, com o texto como veio no arquivo e o motivo.
CREATE VIEW extrato AS
SELECT * FROM read_csv('dados/extrato_pix_marco.csv', header = true, all_varchar = true);

-- A regra da aula. É a mesma em relatorio-conversao.sql, rejeicoes.sql, prova.sql e pix-sem-linha.sql.
CREATE VIEW tratado AS
WITH limpo AS (
    SELECT transacao, data, pedido, valor,
           regexp_replace(upper(trim(coalesce(pedido, ''))), '^PED[- ]?', '') AS pedido_limpo,
           trim(coalesce(valor, ''))                                         AS valor_limpo,
           trim(coalesce(data, ''))                                          AS data_limpa
    FROM extrato
), convertido AS (
    SELECT *,
           CASE WHEN regexp_full_match(pedido_limpo, '[0-9]{1,9}')
                THEN CAST(pedido_limpo AS INTEGER) END                       AS id_pedido,
           CASE WHEN regexp_full_match(valor_limpo, '[0-9]{1,3}(\.[0-9]{3})*,[0-9]{2}')
                THEN CAST(replace(replace(valor_limpo, '.', ''), ',', '.') AS DECIMAL(10, 2))
           END                                                               AS valor_pix,
           CAST(try_strptime(data_limpa, '%d/%m/%Y') AS DATE)                AS data_pix
    FROM limpo
)
SELECT *,
       CASE
           WHEN pedido_limpo = ''  THEN 'pedido vazio'
           WHEN id_pedido IS NULL  THEN 'pedido com letra ou símbolo'
           WHEN NOT EXISTS (SELECT 1 FROM pedidos p WHERE p.id_pedido = c.id_pedido)
                                   THEN 'pedido não existe na loja'
           WHEN valor_limpo = ''   THEN 'valor vazio'
           WHEN valor_pix IS NULL  THEN 'valor fora do formato'
           WHEN data_pix IS NULL   THEN 'data inválida'
       END AS motivo
FROM convertido c;

SELECT transacao,
       '[' || coalesce(data, '') || ']'     AS data_no_arquivo,
       '[' || coalesce(pedido, '') || ']'   AS pedido_no_arquivo,
       '[' || coalesce(valor, '') || ']'    AS valor_no_arquivo,
       motivo
FROM tratado
WHERE motivo IS NOT NULL
ORDER BY transacao;
