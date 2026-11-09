-- Antes de juntar: quantas linhas cada pedido vai virar.
-- Itens x pagamentos x entregas. Quem não tem pagamento ou entrega conta 1,
-- porque o LEFT JOIN mantém o pedido com uma linha vazia do outro lado.
WITH contas AS (
    SELECT p.id_pedido,
           (SELECT COUNT(*) FROM itens_pedido i WHERE i.id_pedido = p.id_pedido) AS itens,
           (SELECT COUNT(*) FROM pagamentos g WHERE g.id_pedido = p.id_pedido)   AS pagamentos,
           (SELECT COUNT(*) FROM entregas e WHERE e.id_pedido = p.id_pedido)     AS entregas
    FROM pedidos p
),
leque AS (
    SELECT *, itens * GREATEST(pagamentos, 1) * GREATEST(entregas, 1) AS vira
    FROM contas
),
faixas AS (
    SELECT CASE WHEN vira = 1 THEN 1 WHEN vira <= 4 THEN 2 WHEN vira <= 8 THEN 3 ELSE 4 END AS ordem,
           vira
    FROM leque
)
SELECT CASE ordem WHEN 1 THEN '1 (não multiplica)' WHEN 2 THEN '2 a 4'
                  WHEN 3 THEN '5 a 8' ELSE '9 ou mais' END AS vira,
       COUNT(*)  AS pedidos,
       SUM(vira) AS linhas,
       MAX(vira) AS maior
FROM faixas
GROUP BY ordem
UNION ALL
SELECT 'total', COUNT(*), SUM(vira), MAX(vira) FROM faixas
ORDER BY maior, pedidos;
