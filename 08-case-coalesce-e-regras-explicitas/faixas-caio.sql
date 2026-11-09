-- A primeira versão das faixas, do jeito que o Caio escreveu.
-- Rode de dentro da pasta da aula: python3 consultar.py --dados ../dados --arquivo faixas-caio.sql
WITH por_pedido AS (
    SELECT p.id_pedido, p.status,
           SUM(i.quantidade * i.preco_unitario - i.desconto) AS valor
    FROM pedidos p
    JOIN itens_pedido i ON i.id_pedido = p.id_pedido
    GROUP BY p.id_pedido, p.status
)
SELECT
    CASE
        WHEN valor > 349 THEN 'mais de 349'
        WHEN valor > 199 THEN 'de 199 a 349'
        ELSE 'até 199'
    END                                              AS faixa,
    COUNT(*)                                         AS pedidos,
    COUNT(*) FILTER (WHERE valor IS NULL)            AS valor_vazio,
    COUNT(*) FILTER (WHERE status IN ('cancelado', 'devolvido')) AS cancelado_ou_devolvido
FROM por_pedido
GROUP BY faixa
ORDER BY faixa;
