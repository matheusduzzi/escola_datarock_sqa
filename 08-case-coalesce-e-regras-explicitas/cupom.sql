-- Quantos itens tiveram cupom? Vazio, zero e desconto de verdade são coisas diferentes.
-- Rode de dentro da pasta da aula: python3 consultar.py --dados ../dados --arquivo cupom.sql
SELECT
    COUNT(*)                                          AS itens,
    COUNT(*) FILTER (WHERE desconto IS NULL)          AS vazio,
    COUNT(*) FILTER (WHERE desconto = 0)              AS zero,
    COUNT(*) FILTER (WHERE desconto > 0)              AS com_desconto,
    -- CASE simples compara desconto = NULL, e essa comparação nunca é verdadeira
    COUNT(*) FILTER (WHERE (CASE desconto WHEN NULL THEN 'sem cupom' END) IS NOT NULL)
                                                      AS case_when_null,
    -- COALESCE antes de classificar junta o vazio com o zero
    COUNT(*) FILTER (WHERE COALESCE(desconto, 0) = 0) AS coalesce_e_zero
FROM itens_pedido;
