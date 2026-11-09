-- Folha 3. O modelo físico das trocas no DuckDB.
-- As três tabelas do começo já estão prontas e são carregadas com a base da loja.
-- Escreva a sua tabela nova no lugar indicado, depois os INSERT das solicitações
-- que o banco deve aceitar, e no fim troque o SELECT pela sua consulta de regras.

CREATE SCHEMA loja;

CREATE TABLE loja.produtos (
    id_produto  INTEGER PRIMARY KEY,
    nome        VARCHAR NOT NULL,
    categoria   VARCHAR NOT NULL,
    preco_lista DECIMAL(10, 2) NOT NULL CHECK (preco_lista > 0)
);

CREATE TABLE loja.pedidos (
    id_pedido        INTEGER PRIMARY KEY,
    id_cliente       INTEGER NOT NULL,
    data_hora_pedido TIMESTAMP NOT NULL,
    canal            VARCHAR NOT NULL,
    status           VARCHAR NOT NULL
);

CREATE TABLE loja.itens_pedido (
    id_pedido      INTEGER NOT NULL REFERENCES loja.pedidos (id_pedido),
    n_item         INTEGER NOT NULL,
    id_produto     INTEGER NOT NULL REFERENCES loja.produtos (id_produto),
    quantidade     INTEGER NOT NULL CHECK (quantidade >= 1),
    preco_unitario DECIMAL(10, 2) NOT NULL,
    desconto       DECIMAL(10, 2),
    PRIMARY KEY (id_pedido, n_item)
);

INSERT INTO loja.produtos SELECT * FROM produtos;
INSERT INTO loja.pedidos SELECT * FROM pedidos;
INSERT INTO loja.itens_pedido SELECT * FROM itens_pedido;

-- 1. Escreva aqui o CREATE TABLE da tabela nova.


-- 2. Escreva aqui os INSERT das solicitações que o banco deve aceitar.


-- 3. Troque este SELECT pela consulta que lista as trocas que quebram
--    as regras que ficaram fora do banco.
SELECT
    (SELECT COUNT(*) FROM loja.produtos) AS produtos,
    (SELECT COUNT(*) FROM loja.pedidos) AS pedidos,
    (SELECT COUNT(*) FROM loja.itens_pedido) AS itens;
