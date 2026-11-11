-- Carrega as quatro tabelas que o controle usa na memória, uma vez, antes das etapas.
-- Sem este arquivo, cada tabela da base é uma view que lê o CSV de novo toda vez que aparece numa consulta.
-- Rodar ANTES das etapas: python3 projeto.py carregar-tabelas.sql etapas.sql testes.sql
-- Os CSVs não mudam. As etapas e os testes ficam como estão: eles continuam lendo pelos mesmos nomes.
CREATE TABLE copia_pedidos AS FROM pedidos;
DROP VIEW pedidos;
ALTER TABLE copia_pedidos RENAME TO pedidos;

CREATE TABLE copia_entregas AS FROM entregas;
DROP VIEW entregas;
ALTER TABLE copia_entregas RENAME TO entregas;

CREATE TABLE copia_itens AS FROM itens_pedido;
DROP VIEW itens_pedido;
ALTER TABLE copia_itens RENAME TO itens_pedido;

CREATE TABLE copia_produtos AS FROM produtos;
DROP VIEW produtos;
ALTER TABLE copia_produtos RENAME TO produtos;

SELECT 'pedidos' AS tabela, COUNT(*) AS linhas FROM pedidos
UNION ALL SELECT 'entregas', COUNT(*) FROM entregas
UNION ALL SELECT 'itens_pedido', COUNT(*) FROM itens_pedido
UNION ALL SELECT 'produtos', COUNT(*) FROM produtos
ORDER BY tabela;
