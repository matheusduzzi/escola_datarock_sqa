-- O valor de cada pedido, com e sem COALESCE no desconto.
-- Rode de dentro da pasta da aula: python3 consultar.py --dados ../dados --arquivo valor-do-pedido.sql
WITH por_pedido AS (
    SELECT
        id_pedido,
        -- sem COALESCE: item sem cupom tem desconto vazio, e a conta do item dá vazio
        SUM(quantidade * preco_unitario - desconto)              AS valor_sem_coalesce,
        -- com COALESCE: desconto vazio quer dizer "sem cupom", e sem cupom o desconto é R$ 0
        SUM(quantidade * preco_unitario - COALESCE(desconto, 0)) AS valor_com_coalesce
    FROM itens_pedido
    GROUP BY id_pedido
)
SELECT
    COUNT(*)                                                         AS pedidos,
    COUNT(*) FILTER (WHERE valor_sem_coalesce IS NULL)               AS sem_coalesce_vazio,
    COUNT(*) FILTER (WHERE valor_sem_coalesce < valor_com_coalesce)  AS sem_coalesce_menor,
    CAST(SUM(valor_sem_coalesce) AS DECIMAL(12, 2))                  AS soma_sem_coalesce,
    CAST(SUM(valor_com_coalesce) AS DECIMAL(12, 2))                  AS soma_com_coalesce
FROM por_pedido;
