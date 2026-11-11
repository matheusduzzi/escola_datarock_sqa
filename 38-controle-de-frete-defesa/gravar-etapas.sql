-- Grava as duas primeiras etapas como tabelas, para as outras etapas e os testes lerem o resultado pronto.
-- É a materialização da aula 29, «Views e materialização». Serve para medir se vale a pena.
-- Rodar DEPOIS das etapas: python3 medir.py carregar-tabelas.sql etapas.sql gravar-etapas.sql testes.sql
-- As views seguintes procuram cobrancas e frete_por_pedido pelo nome e passam a ler as tabelas.
CREATE TABLE gravada_cobrancas AS FROM cobrancas;
CREATE TABLE gravada_frete_por_pedido AS FROM frete_por_pedido;
DROP VIEW frete_por_pedido;
DROP VIEW cobrancas;
ALTER TABLE gravada_cobrancas RENAME TO cobrancas;
ALTER TABLE gravada_frete_por_pedido RENAME TO frete_por_pedido;

SELECT 'cobrancas' AS tabela, COUNT(*) AS linhas FROM cobrancas
UNION ALL SELECT 'frete_por_pedido', COUNT(*) FROM frete_por_pedido
ORDER BY tabela;
