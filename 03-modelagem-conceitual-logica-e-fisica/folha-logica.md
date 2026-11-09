# Folha 2. O modelo lógico das trocas

Seu nome:

Agora sim: tabelas, colunas, chave e para onde cada coluna aponta. Ainda sem tipo de dado do DuckDB. As tabelas `pedidos`, `itens_pedido` e `produtos` já existem; descreva só o que você acrescenta.

## A tabela nova

Nome da tabela:

Uma linha é:

Chave:

Por que essa chave, e não outra:

| Coluna | O que guarda | Pode ficar vazia? Quando? | Aponta para |
|---|---|---|---|
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |

## Onde mora cada regra

Para cada regra da folha 1, diga se ela vira chave, chave estrangeira, NOT NULL ou CHECK, ou se fica fora do banco, numa consulta que procura quem quebra a regra. Se ficar fora, diga por quê.

| Regra | Onde mora | Por quê |
|---|---|---|
| | | |
| | | |
| | | |

## O que o banco fez com cada solicitação

Depois de rodar o `troca-fisico.sql`, preencha. Nas solicitações que o banco recusou, cole a mensagem do DuckDB.

| # | O banco aceitou? | Quebra alguma regra? Qual? | Quem pegou: o banco ou a sua consulta |
|---|---|---|---|
| 1 | | | |
| 2 | | | |
| 3 | | | |
| 4 | | | |
| 5 | | | |
| 6 | | | |
| 7 | | | |
| 8 | | | |
