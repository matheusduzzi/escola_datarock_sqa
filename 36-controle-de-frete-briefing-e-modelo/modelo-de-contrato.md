# Modelo de contrato de métricas

Copie este arquivo e preencha. O `contrato-do-frete.md` da pasta é um exemplo preenchido.

## A pergunta

Cole a mensagem de quem pediu, com as palavras dela.

## Regras que valem para todas as métricas

- **Pedidos que entram:** (coluna e valor; o que acontece com cancelados e devolvidos)
- **O que é o frete de um pedido:** (quais linhas de `entregas` entram)
- **Período:** (`>=` o primeiro dia, `<` o primeiro dia do período seguinte)
- **Cada coluna que pode vir vazia e o que o vazio quer dizer:** (uma linha por coluna)
- **Quando um período pode ser comparado com outro:**
- **Arredondamento:** (onde arredonda e onde não arredonda)

## Métricas

Repita o bloco para cada métrica.

### Nome da métrica

- **Responde:** (a frase que a métrica responde, na língua de quem pediu)
- **Soma:** (coluna e filtro, com nome de coluna e valor)
- **Divide por:** (o que é contado no divisor, ou "nada" quando sai em reais)
- **Data que diz o mês:** (tabela.coluna)
- **Sai por:** (mês, transportadora, categoria)
- **Regra de rateio e motivo:** (só quando o número é dividido entre itens ou categorias)

## O que fica fora

O que a métrica não responde e por quê: coluna que não existe, dado que não chegou, comparação que não vale.

## Modelo de análise

| Etapa | Uma linha por | Vem de | O que acrescenta |
|---|---|---|---|
| | | | |

## Cenários fixos

Pedidos escolhidos para testar cada regra, com o resultado calculado a partir das linhas das tabelas.

| Pedido | O que testa | Números esperados |
|---|---|---|
| | | |

Número do período inteiro que a consulta tem que dar:

## Verificações

Uma por família: chave, total, vazio, fronteira. Mais o fechamento do rateio, se houver.

## Premissas

O que o modelo supõe sobre os dados, cada uma com a consulta que conta os casos contra.
