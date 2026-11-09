-- Tentativa de guardar uma regra de negócio dentro do CHECK:
-- "uma devolução só pode existir para um pedido com status devolvido".
-- A regra olha outra tabela (pedidos). Rode e leia a mensagem do DuckDB.

CREATE SCHEMA loja;

CREATE TABLE loja.pedidos (
    id_pedido INTEGER PRIMARY KEY,
    status    VARCHAR NOT NULL
);

CREATE TABLE loja.entregas (
    id_entrega INTEGER PRIMARY KEY,
    id_pedido  INTEGER NOT NULL REFERENCES loja.pedidos (id_pedido),
    tipo       VARCHAR NOT NULL,
    CHECK (tipo = 'ida' OR id_pedido IN (SELECT id_pedido FROM loja.pedidos WHERE status = 'devolvido'))
);

SELECT 'tabelas criadas' AS resultado;
