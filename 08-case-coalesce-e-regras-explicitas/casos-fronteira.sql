-- Os casos de fronteira da tabela de decisão, passados pela mesma regra.
-- Rode de dentro da pasta da aula: python3 consultar.py --dados ../dados --arquivo casos-fronteira.sql

-- Parte 1: a regra da tabela de decisão, escrita uma vez (igual em faixas.sql e casos-fronteira.sql).
CREATE MACRO faixa_campanha(status, valor) AS
    CASE
        WHEN status IN ('cancelado', 'devolvido')                     THEN 'fora da campanha'
        WHEN status IN ('entregue', 'em_andamento') AND valor < 199   THEN 'menos de 199'
        WHEN status IN ('entregue', 'em_andamento') AND valor <= 349  THEN 'de 199 a 349'
        WHEN status IN ('entregue', 'em_andamento') AND valor > 349   THEN 'mais de 349'
        ELSE 'revisar'
    END;

-- Parte 2: um caso por linha da tabela de decisão, com a faixa que a tabela pede.
SELECT
    caso, status, valor, esperado,
    faixa_campanha(status, valor)                    AS faixa,
    faixa_campanha(status, valor) = esperado         AS bate
FROM (VALUES
    (1, 'entregue',     198.99, 'menos de 199'),
    (2, 'entregue',     199.00, 'de 199 a 349'),
    (3, 'em_andamento', 349.00, 'de 199 a 349'),
    (4, 'entregue',     349.01, 'mais de 349'),
    (5, 'cancelado',    500.00, 'fora da campanha'),
    (6, 'devolvido',    150.00, 'fora da campanha'),
    (7, 'entregue',     NULL,   'revisar'),
    (8, 'em_transito',  250.00, 'revisar')
) AS t(caso, status, valor, esperado)
ORDER BY caso;
