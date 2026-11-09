-- Pedido 1 da prática: seis chaves do extrato no TRY_CAST e na regra da aula.
WITH v(t) AS (VALUES (' 305'), ('000311'), ('PED-324'), ('4O4'), ('1090'), (NULL))
SELECT '[' || coalesce(t, '') || ']'                                           AS pedido_no_arquivo,
       TRY_CAST(t AS INTEGER)                                                  AS try_cast,
       CASE WHEN regexp_full_match(regexp_replace(upper(trim(coalesce(t, ''))), '^PED[- ]?', ''), '[0-9]{1,9}')
            THEN CAST(regexp_replace(upper(trim(coalesce(t, ''))), '^PED[- ]?', '') AS INTEGER) END AS regra_da_aula
FROM v;
