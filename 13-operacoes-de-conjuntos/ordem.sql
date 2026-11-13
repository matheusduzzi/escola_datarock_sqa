-- Qual operação roda primeiro? O INTERSECT vem antes do EXCEPT.
-- A pergunta: quais produtos do romaneio não apareceram nas duas docas?
SELECT produto FROM romaneio
EXCEPT
SELECT produto FROM doca1
INTERSECT
SELECT produto FROM doca2
ORDER BY produto;
