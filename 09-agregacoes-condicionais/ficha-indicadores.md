# Ficha dos indicadores

Uma linha por indicador. Antes de escrever o SQL, complete a frase "de cada 100 ..., quantos ...". O que vem depois de "de cada 100" é o denominador. O que vem depois de "quantos" é o numerador.

## Ficha 1: pedidos por categoria (a do Renato, preenchida na aula)

**O grão da conta.** Um pedido dentro de uma categoria. Um pedido com Casa e Eletro conta uma vez em Casa e uma vez em Eletro.

| Indicador | De cada 100 ..., quantos ... | Numerador | Denominador | Fica fora do denominador, e por quê |
|---|---|---|---|---|
| `pct_cancelado` | De cada 100 pedidos com a categoria, quantos foram cancelados | pedidos com status `cancelado` | todos os pedidos com a categoria | nada: todo pedido pode ser cancelado |
| `pct_devolvido` | De cada 100 pedidos com a categoria que chegaram ao cliente, quantos voltaram | pedidos com status `devolvido` | pedidos com status `entregue` ou `devolvido` | `cancelado`, que nunca saiu da loja, e `em_andamento`, que ainda não chegou |
| `vendas` | (soma, não é taxa) | valor dos itens da categoria | não tem | `cancelado` e `devolvido`, a regra de venda do Renato da aula 05 |

**A linha da loja inteira.** 900 pedidos, 71 cancelados (7,9%), 797 que chegaram, 50 devolvidos (6,3%). As linhas das categorias somam 1.378 pedidos, porque um pedido aparece em cada categoria que tem. As vendas das categorias somam R$ 190.536,30, o mesmo da loja inteira.

## Ficha 2: entregas por transportadora (a sua)

**O grão da conta.**

| Indicador | De cada 100 ..., quantos ... | Numerador | Denominador | Fica fora do denominador, e por quê |
|---|---|---|---|---|
| `pct_nao_encontrado` | | | | |
| `pct_primeira` | | | | |
| `frete_medio` | | | | |

**A linha das duas transportadoras juntas.**

**A resposta para a Marta.**
