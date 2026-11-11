# Pedido da Lúcia: Esporte dia a dia

"Esporte parou em abril. Quero ver o fim de março dia a dia, para entender se foi caindo ou se parou de uma vez. E me diga quando voltou a vender."

## O que cada linha precisa ter

| Decisão | O que vale |
|---|---|
| O que é uma linha | Um dia do calendário |
| Período da tabela | De 23/03/2026 a 05/04/2026, os dois dias incluídos |
| O que se conta | Pedidos com pelo menos um item de Esporte, cada pedido uma vez por dia |
| Quando é zero | Dia do período sem nenhum pedido de Esporte. A loja teve pedido em todos os dias do período |
| Dia anterior | O dia de antes no calendário, com os pedidos de Esporte dele. Vale também para o primeiro dia do período |
| Variação | Diferença em pedidos sempre que houver dia anterior; percentual só quando o dia anterior teve pedido de Esporte |
| Leitura | Uma coluna que diz, em cada linha, se o dia é comparável ou por que não é |

A base tem os pedidos de 01/01/2026 a 20/06/2026.

## O que o Caio mandou

"Rodei o `diario-do-caio.sql`. Em 27/03 Esporte dobrou em relação ao dia anterior, 100% a mais. 23/03 não tem dia anterior porque é o primeiro dia do período. E depois de 31/03 não aparece mais nada."

## As três perguntas

1. Quantas linhas tem a tabela, e quantos pedidos de Esporte teve o dia anterior a 23/03?
2. Quais dias ficam sem percentual, e por quê? Diga o que aconteceu em 27/03.
3. Depois do último pedido de Esporte de março, em que dia veio o próximo pedido de Esporte, e quantos dias depois?
