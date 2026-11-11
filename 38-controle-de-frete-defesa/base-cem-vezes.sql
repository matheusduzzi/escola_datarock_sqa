-- Monta na memória uma base cem vezes maior, para medir o controle com mais linhas.
-- Cada pedido vira cem pedidos iguais, com ids diferentes (o id ganha 100000, 200000, ...).
-- Os CSVs não mudam. As contagens ficam cem vezes maiores; o custo por pedido de cada mês fica o mesmo.
-- Rodar ANTES das etapas: python3 medir.py base-cem-vezes.sql etapas.sql controle-mensal.sql
CREATE TABLE copia_pedidos AS
SELECT p.* REPLACE (p.id_pedido + k * 100000 AS id_pedido)
FROM pedidos p, range(100) AS copias(k);
DROP VIEW pedidos;
ALTER TABLE copia_pedidos RENAME TO pedidos;

CREATE TABLE copia_entregas AS
SELECT e.* REPLACE (e.id_entrega + k * 100000 AS id_entrega, e.id_pedido + k * 100000 AS id_pedido)
FROM entregas e, range(100) AS copias(k);
DROP VIEW entregas;
ALTER TABLE copia_entregas RENAME TO entregas;

CREATE TABLE copia_itens AS
SELECT i.* REPLACE (i.id_pedido + k * 100000 AS id_pedido)
FROM itens_pedido i, range(100) AS copias(k);
DROP VIEW itens_pedido;
ALTER TABLE copia_itens RENAME TO itens_pedido;

CREATE TABLE copia_produtos AS FROM produtos;
DROP VIEW produtos;
ALTER TABLE copia_produtos RENAME TO produtos;

SELECT 'pedidos' AS tabela, COUNT(*) AS linhas FROM pedidos
UNION ALL SELECT 'entregas', COUNT(*) FROM entregas
UNION ALL SELECT 'itens_pedido', COUNT(*) FROM itens_pedido
ORDER BY tabela;
