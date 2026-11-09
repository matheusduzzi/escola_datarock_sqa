# Folha do modelo estrela

Salve uma cópia com o seu nome. A primeira parte é o modelo das vendas, preenchido como na aula. A segunda é o seu: o fato das entregas, que a Marta pediu.

## Modelo 1: vendas (preenchido)

**A pergunta.** Vendas por mês e categoria, sem cancelados e devolvidos, cortando por canal e por UF do cliente.

**O processo.** A venda de um produto num pedido.

**O grão.** Uma linha do fato é um produto dentro de um pedido (um item), com a data do pedido.

**Por que esse grão.** 363 dos 900 pedidos têm itens de mais de uma categoria. Um fato com uma linha por pedido não separa a venda por categoria. O item é a menor linha que o sistema guarda para a venda, e qualquer total por pedido sai somando os itens.

**A tabela fato: `fato_vendas`**

| Coluna | O que é | De onde vem |
|---|---|---|
| `id_pedido`, `n_item` | a chave do fato; o `id_pedido` fica sem tabela própria | `itens_pedido` |
| `data` | liga com `dim_data` | `pedidos.data_hora_pedido`, só a data |
| `id_cliente` | liga com `dim_cliente` | `pedidos` |
| `id_produto` | liga com `dim_produto` | `itens_pedido` |
| `canal`, `status` | atributos do pedido que ficam no fato | `pedidos` |
| `quantidade` | medida, soma | `itens_pedido` |
| `valor_bruto` | medida, soma: quantidade vezes o preço pago | `itens_pedido` |
| `desconto` | medida, soma; vazio vira 0 | `itens_pedido` |
| `valor_liquido` | medida, soma: bruto menos desconto | `itens_pedido` |

**As dimensões**

| Dimensão | Uma linha é | Chave | Colunas | Por que está aqui |
|---|---|---|---|---|
| `dim_data` | um dia do semestre | `data` | ano, mes, ano_mes, dia_semana | O Renato corta por mês; o calendário tem todos os dias, com venda ou sem. |
| `dim_produto` | um produto | `id_produto` | produto, categoria | A categoria é do produto, não do pedido. |
| `dim_cliente` | um cliente | `id_cliente` | cidade, uf | O corte por UF. |

**O que ficou de fora e por quê.**

- O preço de tabela (`produtos.preco_lista`): 246 itens foram vendidos por outro preço. O valor da venda é o que foi pago, e ele já está no fato.
- O frete: ele é de outro grão, uma tentativa de entrega. Copiado em cada item, ele soma R$ 32.244,48 contra R$ 17.910,52 da tabela `entregas`.

**A prova.** O fato tem 1.570 linhas, a mesma quantidade de `itens_pedido`, e 1.570 combinações de `id_pedido + n_item`. A soma do `valor_liquido` dá 223.480,76, igual à soma dos itens. Nenhuma linha do fato fica sem par nas três dimensões.

## Modelo 2: entregas (o seu)

**A pergunta.** O frete por transportadora e mês da saída, separando ida e devolução, com quantas tentativas não acharam ninguém. Depois, o mesmo por UF do cliente.

**O processo.**

**O grão.**

**Por que esse grão (com o número).**

**A tabela fato: `fato_entregas`**

| Coluna | O que é | De onde vem |
|---|---|---|
| | | |

**As dimensões**

| Dimensão | Uma linha é | Chave | Colunas | Por que está aqui |
|---|---|---|---|---|
| | | | | |

**O que ficou de fora e por quê.**

**A prova.** (linhas, chave, soma do frete e linhas sem par nas dimensões, cada uma com o número da sua consulta)

**A resposta para a Marta: março de 2026.**

| transportadora | tipo | linhas | não encontrou | frete |
|---|---|---|---|---|
| | | | | |
