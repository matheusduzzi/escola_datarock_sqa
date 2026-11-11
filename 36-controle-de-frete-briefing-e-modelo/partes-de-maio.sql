-- O frete dos pedidos de maio separado pelo que cada linha da tabela entregas é:
-- a entrega que deu certo, a tentativa que falhou ou a volta de uma devolução.
WITH linhas AS (
    SELECT e.*
    FROM entregas e
    JOIN pedidos p USING (id_pedido)
    WHERE p.data_hora_pedido >= TIMESTAMP '2026-05-01 00:00:00'
      AND p.data_hora_pedido <  TIMESTAMP '2026-06-01 00:00:00'
      AND p.status <> 'cancelado'
),
partes AS (
    SELECT CASE WHEN tipo = 'devolucao' THEN 'devolução'
                WHEN resultado = 'nao_encontrado' THEN 'tentativa que falhou'
                WHEN resultado = 'entregue' THEN 'entrega'
                ELSE 'na rua' END AS parte,
           COUNT(*) AS linhas,
           SUM(custo_frete) AS frete
    FROM linhas
    GROUP BY 1
)
SELECT parte, linhas, ROUND(frete, 2) AS frete, ROUND(100 * frete / SUM(frete) OVER (), 1) AS pct_do_frete
FROM partes
ORDER BY frete DESC;
