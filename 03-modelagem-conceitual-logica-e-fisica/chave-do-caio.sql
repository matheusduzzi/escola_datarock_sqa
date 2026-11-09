-- A mesma criação, com a chave que o Caio escreveu: pedido, volume e tentativa, sem o tipo.
-- Rode e leia a mensagem do DuckDB.

CREATE SCHEMA loja;

CREATE TABLE loja.pedidos (
    id_pedido        INTEGER PRIMARY KEY,
    id_cliente       INTEGER NOT NULL,
    data_hora_pedido TIMESTAMP NOT NULL,
    canal            VARCHAR NOT NULL CHECK (canal IN ('site', 'app', 'loja')),
    status           VARCHAR NOT NULL
                     CHECK (status IN ('entregue', 'cancelado', 'devolvido', 'em_andamento'))
);

CREATE TABLE loja.entregas (
    id_entrega     INTEGER PRIMARY KEY,
    id_pedido      INTEGER NOT NULL REFERENCES loja.pedidos (id_pedido),
    volume         INTEGER NOT NULL CHECK (volume >= 1),
    tentativa      INTEGER NOT NULL CHECK (tentativa >= 1),
    tipo           VARCHAR NOT NULL CHECK (tipo IN ('ida', 'devolucao')),
    transportadora VARCHAR NOT NULL,
    data_saida     DATE NOT NULL,
    data_tentativa DATE,                -- vazia enquanto o volume está na rua
    resultado      VARCHAR CHECK (resultado IN ('entregue', 'nao_encontrado', 'recebido_cd')),
    custo_frete    DECIMAL(10, 2) CHECK (custo_frete >= 0),  -- vazio até a fatura chegar
    UNIQUE (id_pedido, volume, tentativa),  -- a chave que o Caio escreveu
    CHECK (data_tentativa IS NULL OR data_tentativa >= data_saida),
    CHECK ((resultado IS NULL) = (data_tentativa IS NULL))
);

INSERT INTO loja.pedidos SELECT * FROM pedidos;
INSERT INTO loja.entregas SELECT * FROM entregas;

SELECT
    (SELECT COUNT(*) FROM loja.pedidos) AS pedidos,
    COUNT(*) AS entregas,
    SUM(custo_frete) AS frete,
    ANY_VALUE(typeof(custo_frete)) AS tipo_do_frete
FROM loja.entregas;
