-- Monta a planilha de novo a partir das tabelas da base (../dados) e compara coluna por coluna.
-- Na base, cada fato está escrito uma vez: na tabela clientes, produtos ou pedidos.
WITH base AS (
    SELECT i.id_pedido, i.n_item, c.cidade, pr.categoria, p.status
    FROM read_csv_auto('../dados/itens_pedido.csv', header = true) AS i
    JOIN read_csv_auto('../dados/pedidos.csv', header = true) AS p USING (id_pedido)
    JOIN read_csv_auto('../dados/clientes.csv', header = true) AS c USING (id_cliente)
    JOIN read_csv_auto('../dados/produtos.csv', header = true) AS pr USING (id_produto)
)
SELECT COUNT(*) AS linhas,
       COUNT(*) FILTER (WHERE v.cidade <> b.cidade) AS cidade_diferente,
       COUNT(*) FILTER (WHERE v.categoria <> b.categoria) AS categoria_diferente,
       COUNT(*) FILTER (WHERE v.status <> b.status) AS status_diferente
FROM vendas_larga AS v
JOIN base AS b USING (id_pedido, n_item);
