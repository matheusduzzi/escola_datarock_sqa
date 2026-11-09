-- Textos que o TRY_CAST para inteiro aceita, e o que a regra da aula faz com eles.
SELECT t                                         AS texto,
       TRY_CAST(t AS INTEGER)                    AS try_cast,
       regexp_full_match(trim(t), '[0-9]{1,9}')  AS so_digitos
FROM (VALUES ('464'), (' 464'), ('000464'), ('464.0'), ('+464'), ('1e3'), ('46.5')) AS v(t);
