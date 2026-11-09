# O pedido da Marta

> Oi! Vou levar o frete do semestre para a conversa com a TransVale e a Rota Leve. Quero ver por semana, de segunda a domingo, pela data da tentativa de entrega: quantas viagens de entrega, quantas devoluções voltaram para o CD e quanto pagamos de frete, no total e por viagem. O Caio já mandou uma consulta. Antes de eu levar, preciso que você me diga o que cada número quer dizer.

## Como a entrega funciona

- O volume sai do CD de 1 a 3 dias depois do pedido.
- Cada tentativa de entrega acontece de 1 a 3 dias depois da anterior. A primeira acontece de 1 a 3 dias depois da saída do CD. São no máximo três tentativas.
- Quando o cliente devolve, a transportadora leva o volume de volta ao CD de 5 a 9 dias depois da última tentativa. Essa volta é uma linha `devolucao` na tabela `entregas`, e também tem frete.
- O custo de cada viagem entra na base quando a transportadora fatura a viagem. As viagens de 10/06/2026 em diante ainda estão sendo faturadas.
- A base tem os pedidos de 01/01/2026 a 20/06/2026. Os pedidos de 2025 não estão nela.

## As perguntas

1. As semanas de 05/01, 26/01, 20/04 e 15/06 deram zero devolução. Em quais delas eu posso dizer na reunião que nenhuma devolução voltou?
2. O frete por viagem caiu nas duas últimas semanas?
3. De que semana a que semana eu posso comparar as viagens, as devoluções e o frete total, uma semana com a outra?
