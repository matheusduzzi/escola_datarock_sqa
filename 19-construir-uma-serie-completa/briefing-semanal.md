# O pedido da Lúcia

> Oi! A tabela por mês ficou boa. Agora quero a mesma coisa por semana, para ver o detalhe de abril e do começo do ano. O Caio já mandou uma consulta, mas eu quero que você monte a série e me diga se dá para usar os números dele.

## Como a série semanal tem que sair

| Decisão | Série semanal por categoria |
|---|---|
| O que é uma linha | uma semana, de segunda a domingo, e uma categoria |
| O que se conta | pedidos com pelo menos um item da categoria, de qualquer status, pela data do pedido |
| Semanas da tabela | toda semana com pelo menos um dia entre o primeiro e o último dia da base, mesmo as que a base não cobre inteiras; nenhuma semana depois |
| Categorias da tabela | as cinco categorias do catálogo, em todas as semanas |
| Quando é zero | semana na tabela sem nenhum pedido da categoria |
| Cobertura | quantos dos 7 dias da semana a base tem, e a situação: completa ou parcial |
| Média semanal | só as semanas completas, com os zeros dentro |

A base tem os pedidos de 01/01/2026 a 20/06/2026.

## As perguntas

1. Quantas linhas a série tem? De que semana a que semana ela vai, e quais semanas são parciais, com quantos dias?
2. Em que semanas Esporte não teve nenhum pedido? A semana que começa em 30/03 tem pedido de Esporte, e abril inteiro não teve. Como pode?
3. O Caio diz que Esporte tem em média 12,4 pedidos por semana. Que número vai para a reunião, e por que o dele é diferente?
