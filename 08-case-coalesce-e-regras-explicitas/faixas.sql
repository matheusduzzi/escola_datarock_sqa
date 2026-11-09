-- As faixas da campanha de julho, pela tabela de decisão do Renato.
-- Rode de dentro da pasta da aula: python3 consultar.py --dados ../dados --arquivo faixas.sql

-- Parte 1: a regra da tabela de decisão, escrita uma vez (igual em faixas.sql e casos-fronteira.sql).
CREATE MACRO faixa_campanha(status, valor) AS
    CASE
        WHEN status IN ('cancelado', 'devolvido')                     THEN 'fora da campanha'
        WHEN status IN ('entregue', 'em_andamento') AND valor < 199   THEN 'menos de 199'
        WHEN status IN ('entregue', 'em_andamento') AND valor <= 349  THEN 'de 199 a 349'
        WHEN status IN ('entregue', 'em_andamento') AND valor > 349   THEN 'mais de 349'
        ELSE 'revisar'
    END;

-- Parte 2: o valor de cada pedido e a contagem por faixa.
CREATE VIEW valor_pedido AS
SELECT p.id_pedido, p.status,
       CAST(SUM(i.quantidade * i.preco_unitario - COALESCE(i.desconto, 0)) AS DECIMAL(10, 2)) AS valor
FROM pedidos p
LEFT JOIN itens_pedido i ON i.id_pedido = p.id_pedido
GROUP BY p.id_pedido, p.status;

SELECT
    faixa_campanha(status, valor)                    AS faixa,
    COUNT(*)                                         AS pedidos,
    COUNT(*) FILTER (WHERE valor = 199)              AS em_199,
    COUNT(*) FILTER (WHERE valor = 349)              AS em_349
FROM valor_pedido
GROUP BY faixa
ORDER BY MIN(valor) FILTER (WHERE status IN ('entregue', 'em_andamento')) NULLS LAST, faixa;
