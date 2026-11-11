-- Monta o histórico da aula no arquivo historico.duckdb e na pasta historico_por_mes/, nesta pasta.
-- Rodar de novo apaga e recria tudo do mesmo jeito (os índices que você criou somem junto).
--
-- A base da Loja Exemplo tem 900 pedidos, e todos cabem num grupo de linhas só.
-- Para ver o que índice, ordem e partição fazem, esta aula precisa de volume.
-- O histórico abaixo tem 3 milhões de itens, de dezembro de 2021 a junho de 2026,
-- montado por uma regra fixa: os valores e as categorias não são vendas de verdade.
ATTACH 'historico.duckdb' AS hist;

-- itens_historico
--   Uma linha por: item de pedido. 3.000.000 linhas, 2 itens por pedido, 1.500.000 pedidos.
--   Chave: id_item.
--   Ordem física: a da carga. O pedido seguinte é 96 segundos depois do anterior,
--   então id_pedido e data_hora_pedido crescem juntos, como numa loja de verdade.
--   Colunas:
--     id_item, id_pedido  BIGINT    crescem com a data
--     id_cliente          BIGINT    60.001 clientes, espalhados pela tabela toda
--     data_hora_pedido    TIMESTAMP de 2021-12-01 a 2026-06-24
--     canal               VARCHAR   site, app, loja
--     categoria           VARCHAR   Eletro, Casa, Moda, Esporte, Papelaria; 1 item em 2.000 é Presentes
--     valor               DECIMAL(10,2)
CREATE OR REPLACE TABLE hist.itens_historico AS
SELECT i + 1                                                        AS id_item,
       i // 2 + 1                                                   AS id_pedido,
       (i // 2) * 7919 % 60001 + 1                                  AS id_cliente,
       TIMESTAMP '2021-12-01 00:00:00' + to_seconds((i // 2) * 96)  AS data_hora_pedido,
       ['site', 'app', 'loja'][1 + (i // 2) % 3]                    AS canal,
       CASE WHEN i % 2000 = 1999 THEN 'Presentes'
            ELSE ['Eletro', 'Casa', 'Moda', 'Esporte', 'Papelaria'][1 + i * 13 % 5] END AS categoria,
       CAST(10 + (i * 37 + i // 7) % 500 + (i * 11 % 100) / 100 AS DECIMAL(10,2)) AS valor
FROM range(3000000) AS t(i)
ORDER BY i;

-- itens_embaralhados
--   As mesmas 3.000.000 linhas, com a mesma chave e as mesmas colunas,
--   gravadas noutra ordem: a de uma conta que mistura os itens.
--   É como a tabela fica quando a carga não segue a data (um arquivo por loja, um lote reprocessado).
CREATE OR REPLACE TABLE hist.itens_embaralhados AS
SELECT *
FROM hist.itens_historico
ORDER BY id_item * 7919 % 3000017, id_item;

-- historico_por_mes/
--   As mesmas linhas em arquivos Parquet, uma pasta por mês: historico_por_mes/ano=2026/mes=5/...
--   threads = 1 faz o DuckDB gravar um arquivo por pasta, sempre o mesmo número de arquivos.
SET threads = 1;
COPY (SELECT *, year(data_hora_pedido) AS ano, month(data_hora_pedido) AS mes
      FROM hist.itens_historico)
TO 'historico_por_mes' (FORMAT parquet, PARTITION_BY (ano, mes), OVERWRITE_OR_IGNORE);
RESET threads;

-- Conferência da carga: linhas, pedidos, clientes, primeiro e último pedido, e pastas de mês.
SELECT 'itens_historico' AS tabela, COUNT(*) AS linhas, COUNT(DISTINCT id_pedido) AS pedidos,
       COUNT(DISTINCT id_cliente) AS clientes, MIN(data_hora_pedido) AS primeiro, MAX(data_hora_pedido) AS ultimo
FROM hist.itens_historico
UNION ALL
SELECT 'itens_embaralhados', COUNT(*), COUNT(DISTINCT id_pedido), COUNT(DISTINCT id_cliente),
       MIN(data_hora_pedido), MAX(data_hora_pedido)
FROM hist.itens_embaralhados
UNION ALL
SELECT 'historico_por_mes', COUNT(*), COUNT(DISTINCT id_pedido), COUNT(DISTINCT id_cliente),
       MIN(data_hora_pedido), MAX(data_hora_pedido)
FROM read_parquet('historico_por_mes/*/*/*.parquet', hive_partitioning = true);
