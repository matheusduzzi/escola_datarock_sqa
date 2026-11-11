# Modelo de testes de SQL

O formato de cada família de teste, para você adaptar à consulta que está testando. O exemplo completo, rodando, é o `testes-do-fechamento.sql` dessa pasta.

Três regras valem para todos:

- O esperado sai das tabelas, nunca da consulta que está sendo testada.
- O recorte do pedido (status, período) fica escrito uma vez, numa CTE `recorte`, e a consulta testada tem o recorte dela.
- Cada teste tem um nome que diz a família e o que ele olha. Rode cada teste contra a versão errada e veja ele falhar.

Nos exemplos, `resultado` é a etapa da consulta testada com uma linha por pedido.

## Chave

Uma linha por pedido, nenhum faltando, nenhum de fora.

```sql
-- pedidos repetidos: esperado 0
SELECT COUNT(*) - COUNT(DISTINCT id_pedido) FROM resultado;

-- pedidos do recorte que faltam: esperado 0
SELECT COUNT(*) FROM recorte
WHERE id_pedido NOT IN (SELECT id_pedido FROM resultado);

-- pedidos fora do recorte: esperado 0
SELECT COUNT(*) FROM resultado
WHERE id_pedido NOT IN (SELECT id_pedido FROM recorte);
```

O `NOT IN` serve porque `id_pedido` nunca vem vazio. Se a coluna puder ter NULL, use `NOT EXISTS`.

## Total

A soma do resultado contra a tabela somada sozinha, com os pedidos do recorte. Dinheiro em centavos.

```sql
-- obtido
SELECT ROUND(SUM(valor_itens), 2) FROM resultado;

-- esperado: uma tabela por vez, sem JOIN com as outras tabelas de fato
SELECT ROUND(SUM(quantidade * preco_unitario - COALESCE(desconto, 0)), 2)
FROM itens_pedido
WHERE id_pedido IN (SELECT id_pedido FROM recorte);
```

## Valor vazio

Antes de escrever, decida o que o vazio quer dizer na coluna: "não entrou nada" (zero) ou "ainda não sei" (conte e mostre).

```sql
-- linhas com a coluna vazia no resultado: esperado 0, ou o número tirado da tabela
SELECT COUNT(*) - COUNT(recebido) FROM resultado;

-- contas que ficam vazias por causa de um NULL: esperado 0
SELECT COUNT(*) FROM resultado WHERE valor_itens - recebido IS NULL;
```

## Fronteira

As duas pontas do período, com os casos de borda pelo `id_pedido` ou pelo dia.

```sql
-- pedidos do último dia: esperado = os pedidos desse dia na tabela de pedidos
SELECT COUNT(*) FROM resultado
WHERE id_pedido IN (SELECT id_pedido FROM pedidos
                    WHERE CAST(data_hora_pedido AS DATE) = DATE '2026-06-20');

-- pedidos do dia anterior ao começo: esperado 0
SELECT COUNT(*) FROM resultado
WHERE id_pedido IN (SELECT id_pedido FROM pedidos
                    WHERE CAST(data_hora_pedido AS DATE) = DATE '2026-05-31');
```

## Juntar tudo num arquivo

Junte os testes numa consulta só, uma linha por teste, com as colunas `teste`, `esperado` e uma coluna por versão. Para que a execução pare quando um teste falha, use `error()` como no `trava-da-revisada.sql`.
