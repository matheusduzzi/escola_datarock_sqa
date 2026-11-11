-- Testes do controle de frete. Rodar depois das etapas:
--   python3 projeto.py etapas.sql testes.sql
-- Os valores da coluna esperado vêm do contrato (cenários fixos e números de maio),
-- calculados antes da consulta existir. Não mude um esperado para o teste passar.
-- O programa sai com código 1 se alguma linha não der ok.

WITH esperado(n, familia, teste, esperado) AS (
    VALUES
    ( 1, 'cenário',    '627: frete e partes',  '15.01 | 15.01 | 0.00 | 0.00 | 1'),
    ( 2, 'cenário',    '636: frete e partes',  '69.70 | 37.26 | 32.44 | 0.00 | 2'),
    ( 3, 'cenário',    '687: frete e partes',  '53.82 | 15.96 | 19.59 | 18.27 | 1'),
    ( 4, 'cenário',    '727: frete e partes',  '37.00 | 16.85 | 0.00 | 20.15 | 1'),
    ( 5, 'cenário',    '767: frete e partes',  '34.20 | 15.31 | 18.89 | 0.00 | 1'),
    ( 6, 'cenário',    '627: rateio',  'Casa 15.01'),
    ( 7, 'cenário',    '636: rateio',  'Casa 7.22; Eletro 62.48'),
    ( 8, 'cenário',    '687: rateio',  'Beleza 23.01; Esporte 15.53; Papelaria 15.29'),
    ( 9, 'cenário',    '727: rateio',  'Casa 1.52; Eletro 31.43; Esporte 4.05'),
    (10, 'cenário',    '767: rateio',  'Casa 18.67; Esporte 15.53'),
    (11, 'cenário',    '727 | 767 nas tentativas de maio',  '16.85 | 18.89'),
    (12, 'mês',        'maio: pedidos não cancelados',  '141'),
    (13, 'mês',        'maio: frete dos pedidos',  '3161.70'),
    (14, 'mês',        'maio: frete das tentativas',  '3141.60'),
    (15, 'mês',        'maio: soma das categorias',  '3161.70'),
    (16, 'mês',        'maio: sem fatura | na rua',  '0 | 0'),
    (17, 'chave',      'pedido repetido',  '0'),
    (18, 'chave',      'item repetido',  '0'),
    (19, 'chave',      'mês e transportadora repetidos',  '0'),
    (20, 'total',      'frete das etapas menos tabela entregas',  '0.00'),
    (21, 'total',      'itens fora do rateio',  '0'),
    (22, 'vazio',      'sem fatura: etapas menos contagem direta',  '0'),
    (23, 'vazio',      'na rua: etapas menos contagem direta',  '0'),
    (24, 'vazio',      'cobrança sem parte',  '0'),
    (25, 'vazio',      'pedido sem mês',  '0'),
    (26, 'fronteira',  '627 | 793 | 794: mês do pedido',  '2026-05 | 2026-05 | 2026-06'),
    (27, 'fechamento', 'maior diferença entre partes e frete',  '0.00'),
    (28, 'janela',     'variação em junho, mês aberto',  '0'),
    (29, 'janela',     'variação em janeiro, sem mês anterior',  '0'),
    (30, 'janela',     'variação TransVale, abril para maio',  '2.83')
),
categorias AS (
    SELECT id_pedido, categoria, SUM(parte_do_frete) AS frete
    FROM rateio_por_item
    WHERE id_pedido IN (627, 636, 687, 727, 767)
    GROUP BY id_pedido, categoria
),
obtido(teste, obtido) AS (
    SELECT id_pedido || ': frete e partes',
           printf('%.2f | %.2f | %.2f | %.2f | %d', frete, entrega, falhou, devolucao, volumes_entregues)
    FROM frete_por_pedido
    WHERE id_pedido IN (627, 636, 687, 727, 767)
    UNION ALL
    SELECT id_pedido || ': rateio',
           string_agg(categoria || ' ' || printf('%.2f', frete), '; ' ORDER BY categoria)
    FROM categorias
    GROUP BY id_pedido
    UNION ALL
    SELECT '727 | 767 nas tentativas de maio',
           printf('%.2f | %.2f',
                  SUM(custo_frete) FILTER (WHERE id_pedido = 727),
                  SUM(custo_frete) FILTER (WHERE id_pedido = 767))
    FROM cobrancas
    WHERE mes_tentativa = DATE '2026-05-01'
    UNION ALL
    SELECT 'maio: pedidos não cancelados', CAST(COUNT(*) AS VARCHAR)
    FROM frete_por_pedido WHERE mes_pedido = DATE '2026-05-01'
    UNION ALL
    SELECT 'maio: frete dos pedidos', printf('%.2f', SUM(frete))
    FROM controle_mensal WHERE mes = DATE '2026-05-01'
    UNION ALL
    SELECT 'maio: frete das tentativas', printf('%.2f', SUM(frete))
    FROM tentativas_do_mes WHERE mes = DATE '2026-05-01'
    UNION ALL
    SELECT 'maio: soma das categorias', printf('%.2f', SUM(frete))
    FROM frete_por_categoria WHERE mes = DATE '2026-05-01'
    UNION ALL
    SELECT 'maio: sem fatura | na rua', printf('%d | %d', SUM(linhas_sem_fatura), SUM(volumes_na_rua))
    FROM controle_mensal WHERE mes = DATE '2026-05-01'
    UNION ALL
    SELECT 'pedido repetido', CAST(COUNT(*) - COUNT(DISTINCT id_pedido) AS VARCHAR)
    FROM frete_por_pedido
    UNION ALL
    SELECT 'item repetido', CAST(COUNT(*) - COUNT(DISTINCT (id_pedido, n_item)) AS VARCHAR)
    FROM rateio_por_item
    UNION ALL
    SELECT 'mês e transportadora repetidos', CAST(COUNT(*) - COUNT(DISTINCT (mes, transportadora)) AS VARCHAR)
    FROM controle_mensal
    UNION ALL
    SELECT 'frete das etapas menos tabela entregas',
           -- ABS: a subtração em ponto flutuante pode dar -0.000000001, que sai como -0.00
           printf('%.2f', ABS((SELECT SUM(frete) FROM frete_por_pedido)
                            - (SELECT SUM(e.custo_frete) FROM entregas e JOIN pedidos p USING (id_pedido)
                               WHERE p.status <> 'cancelado')))
    UNION ALL
    SELECT 'itens fora do rateio',
           CAST((SELECT COUNT(*) FROM itens_pedido i JOIN pedidos p USING (id_pedido) WHERE p.status <> 'cancelado')
              - (SELECT COUNT(*) FROM rateio_por_item) AS VARCHAR)
    UNION ALL
    SELECT 'sem fatura: etapas menos contagem direta',
           CAST((SELECT SUM(linhas_sem_fatura) FROM frete_por_pedido)
              - (SELECT COUNT(*) FROM entregas WHERE custo_frete IS NULL) AS VARCHAR)
    UNION ALL
    SELECT 'na rua: etapas menos contagem direta',
           CAST((SELECT SUM(volumes_na_rua) FROM frete_por_pedido)
              - (SELECT COUNT(*) FROM entregas WHERE tipo = 'ida' AND resultado IS NULL) AS VARCHAR)
    UNION ALL
    SELECT 'cobrança sem parte', CAST(COUNT(*) AS VARCHAR)
    FROM cobrancas WHERE parte IS NULL
    UNION ALL
    SELECT 'pedido sem mês', CAST(COUNT(*) AS VARCHAR)
    FROM frete_por_pedido WHERE mes_pedido IS NULL
    UNION ALL
    SELECT '627 | 793 | 794: mês do pedido',
           string_agg(COALESCE(strftime(mes_pedido, '%Y-%m'), 'fora'), ' | ' ORDER BY id_pedido)
    FROM frete_por_pedido WHERE id_pedido IN (627, 793, 794)
    UNION ALL
    SELECT 'maior diferença entre partes e frete',
           printf('%.2f', MAX(ABS(diferenca)))
    FROM (SELECT r.id_pedido, SUM(r.parte_do_frete) - MAX(f.frete) AS diferenca
          FROM rateio_por_item r JOIN frete_por_pedido f USING (id_pedido)
          GROUP BY r.id_pedido)
    UNION ALL
    SELECT 'variação em junho, mês aberto', CAST(COUNT(variacao_por_pedido) AS VARCHAR)
    FROM controle_mensal WHERE mes = DATE '2026-06-01'
    UNION ALL
    SELECT 'variação em janeiro, sem mês anterior', CAST(COUNT(variacao_por_pedido) AS VARCHAR)
    FROM controle_mensal WHERE mes = DATE '2026-01-01'
    UNION ALL
    SELECT 'variação TransVale, abril para maio', printf('%.2f', variacao_por_pedido)
    FROM controle_mensal WHERE mes = DATE '2026-05-01' AND transportadora = 'TransVale'
)
SELECT e.n, e.familia, e.teste, e.esperado, o.obtido,
       CASE WHEN o.obtido = e.esperado THEN 'ok' ELSE 'FALHA' END AS resultado
FROM esperado e
LEFT JOIN obtido o USING (teste)
ORDER BY e.n;
