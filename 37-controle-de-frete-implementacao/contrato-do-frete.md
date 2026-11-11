# Contrato de métricas: controle de frete

Pedido da Marta, gerente de operações, para a reunião de reajuste com a TransVale. Aprovado por ela antes da consulta. É a base da aula 37, «Controle de frete: implementação».

## A pergunta

"Quanto custa o frete de um pedido, quanto a gente perde com entrega que não dá certo e com devolução, e quanto de frete cada categoria carrega. Comparar TransVale e Rota Leve. Começar por maio, o último mês fechado."

## Regras que valem para todas as métricas

- **Pedidos que entram:** os não cancelados (`status <> 'cancelado'`). Os cancelados não têm linha em `entregas`. Os devolvidos entram.
- **Frete de um pedido:** a soma de `custo_frete` de todas as linhas dele em `entregas`: entregas, tentativas que falharam e devoluções.
- **Transportadora do pedido:** a da linha em `entregas`. Todo pedido usa uma só (premissa 1).
- **Período:** `>=` o primeiro dia do mês às 00:00:00 e `<` o primeiro dia do mês seguinte.
- **Fatura que não chegou** (`custo_frete` vazio): não vira zero. Toda métrica sai com `linhas_sem_fatura` ao lado.
- **Volume na rua** (`tipo = 'ida'` com `resultado` vazio): toda métrica sai com `volumes_na_rua` ao lado.
- **Mês fechado:** `linhas_sem_fatura = 0` e `volumes_na_rua = 0`. Só mês fechado entra numa comparação entre meses.
- **Valor do item:** `quantidade * preco_unitario - desconto`, com desconto vazio contando zero (o item não teve cupom).
- **Arredondamento:** só na saída, para centavos. As contas e os testes usam os valores sem arredondar.

## Métricas

### 1. Custo de frete por pedido

- **Responde:** quanto custou, em média, levar um pedido do mês até o cliente.
- **Soma:** o frete dos pedidos.
- **Divide por:** pedidos não cancelados feitos no mês.
- **Data que diz o mês:** `pedidos.data_hora_pedido`.
- **Sai por:** mês do pedido e transportadora.

### 2. Custo de frete por volume entregue

- **Responde:** quanto custou cada caixa que chegou ao cliente. A TransVale cobra por volume.
- **Soma:** o mesmo frete da métrica 1.
- **Divide por:** linhas com `tipo = 'ida'` e `resultado = 'entregue'` dos pedidos do mês.
- **Data que diz o mês:** `pedidos.data_hora_pedido`.
- **Sai por:** mês do pedido e transportadora.

### 3. Frete das tentativas que falharam

- **Responde:** quanto a loja pagou por tentativas em que o cliente não foi encontrado.
- **Soma:** `custo_frete` das linhas com `resultado = 'nao_encontrado'`.
- **Sai em:** reais e em % do frete dos pedidos do mês.
- **Data que diz o mês:** `pedidos.data_hora_pedido`.

### 4. Frete das devoluções

- **Responde:** quanto a loja pagou para trazer de volta os pedidos devolvidos.
- **Soma:** `custo_frete` das linhas com `tipo = 'devolucao'`. A ida desses pedidos fica na entrega ou na tentativa que falhou.
- **Sai em:** reais e em % do frete dos pedidos do mês.
- **Data que diz o mês:** `pedidos.data_hora_pedido`. A volta de um pedido de maio que chegou em junho fica em maio.

### 5. Frete das tentativas do mês

- **Responde:** quanto a transportadora trabalhou no mês. É para bater com a fatura dela.
- **Soma:** `custo_frete` das linhas com `data_tentativa` no mês, de pedidos de qualquer mês.
- **Data que diz o mês:** `entregas.data_tentativa`. Volume na rua não tem tentativa ainda e fica fora até ter.
- **Sai por:** mês da tentativa e transportadora, com `linhas_sem_fatura`.
- **Não serve para:** dividir por pedidos. Os pedidos do mês e as tentativas do mês são conjuntos diferentes.

### 6. Frete por categoria

- **Responde:** quanto o frete pesa sobre a venda de cada categoria, para decidir o frete grátis.
- **Regra de rateio:** o frete de cada pedido é dividido entre os itens na proporção do valor do item no valor do pedido.
- **Por que o valor:** a pergunta é sobre o peso do frete na venda. A categoria que vende mais por pedido carrega mais frete.
- **Sai em:** reais e em % da venda da categoria nos pedidos do mês (venda com os devolvidos).
- **Data que diz o mês:** `pedidos.data_hora_pedido`.

## O que fica fora

- Rateio por peso ou tamanho: a base não tem essas colunas.
- Bater a métrica 5 centavo por centavo com a fatura: a base não tem a data da fatura, só a da tentativa.
- Comparar um mês aberto com um fechado.

## Modelo de análise

| Etapa | Uma linha por | Vem de | O que acrescenta |
|---|---|---|---|
| `cobrancas` | linha da tabela `entregas` | `entregas` + `pedidos` | parte (entrega, tentativa que falhou, devolução, na rua), mês do pedido, mês da tentativa, transportadora |
| `frete_por_pedido` | pedido não cancelado | `cobrancas` | frete total, as três partes, volumes entregues, linhas sem fatura, volumes na rua |
| `rateio_por_item` | item de pedido | `itens_pedido` + `produtos` + `frete_por_pedido` | valor do item, participação no pedido, parte do frete |
| `controle_mensal` | mês do pedido e transportadora | `frete_por_pedido` | métricas 1 a 4 |
| `frete_por_categoria` | mês do pedido e categoria | `rateio_por_item` | métrica 6 |
| `tentativas_do_mes` | mês da tentativa e transportadora | `cobrancas` | métrica 5 |

O frete é somado por pedido antes de encontrar os itens.

## Cenários fixos

Calculados a partir das linhas de `entregas` e `itens_pedido` desses pedidos, antes da consulta existir. A consulta pronta tem que dar estes números.

| Pedido | O que testa | Frete | Entrega | Tentativa que falhou | Devolução | Volumes entregues | Rateio pelo valor |
|---|---|---|---|---|---|---|---|
| 627 | o primeiro pedido do mês (01/05 00:00:01) entra em maio | 15,01 | 15,01 | 0,00 | 0,00 | 1 | Casa 15,01 |
| 636 | tentativa que falhou nos dois volumes | 69,70 | 37,26 | 32,44 | 0,00 | 2 | Casa 7,22; Eletro 62,48 |
| 687 | as três partes e o centavo do arredondamento | 53,82 | 15,96 | 19,59 | 18,27 | 1 | Beleza 23,01; Esporte 15,53; Papelaria 15,29 |
| 727 | devolução que volta em junho fica em maio | 37,00 | 16,85 | 0,00 | 20,15 | 1 | Casa 1,52; Eletro 31,43; Esporte 4,05 |
| 767 | entrega em junho de um pedido de maio | 34,20 | 15,31 | 18,89 | 0,00 | 1 | Casa 18,67; Esporte 15,53 |

Na métrica 5, o 727 entra em maio com 16,85 e o 767 com 18,89. O resto desses dois pedidos cai em junho.

No 687, as categorias arredondadas somam 53,83. O teste de fechamento compara as partes sem arredondar.

Números do mês de maio:

| Número | Esperado |
|---|---|
| pedidos não cancelados feitos em maio | 141 |
| frete dos pedidos de maio | 3161,70 |
| frete das tentativas de maio (métrica 5) | 3141,60 |
| soma das categorias (métrica 6) | 3161,70 |
| linhas sem fatura e volumes na rua | 0 e 0 |

## Verificações

As quatro famílias da aula 35, «Testar e revisar SQL», mais o fechamento do rateio:

- **Chave:** uma linha por pedido em `frete_por_pedido`; uma por item em `rateio_por_item`.
- **Total:** o frete de `frete_por_pedido` soma o mesmo que a tabela `entregas` filtrada pelos pedidos do mês.
- **Vazio:** `linhas_sem_fatura` e `volumes_na_rua` iguais à contagem direta na tabela `entregas`.
- **Fronteira:** o 627 (01/05 às 00:00:01) e o 793 (31/05 às 20:03), o primeiro e o último pedido de maio, entram em maio; o 794 (01/06 às 01:33) não.
- **Fechamento do rateio:** a soma das partes de cada pedido, sem arredondar, menos o frete do pedido dá 0 em centavos.

## Premissas

Rodadas pelo `premissas-do-modelo.sql`. O modelo vale enquanto todas dão 0.

1. Nenhum pedido com mais de uma transportadora.
2. Nenhum pedido cancelado com linha em `entregas`.
3. Nenhum pedido não cancelado sem linha em `entregas`.
4. Todo pedido devolvido com exatamente uma devolução.
5. Nenhuma devolução em pedido que não está devolvido.
6. Nenhum pedido com valor dos itens zero ou negativo.
7. Nenhuma linha repetida em `entregas` para o mesmo pedido, volume, tentativa e tipo.
