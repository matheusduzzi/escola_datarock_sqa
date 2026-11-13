# Base da Loja Exemplo

Os pedidos da Loja Exemplo de 1º de janeiro a 20 de junho de 2026, com os itens, os pagamentos e as entregas de cada pedido. É a base das práticas do curso, do bloco 1 ao projeto de frete. Quando uma aula precisa de outra tabela, como o histórico de endereço ou o caso de crédito, os arquivos ficam na pasta dela.

A Loja Exemplo é a mesma de Primeiros passos em dados, mas essa base é outra: aqui cada pedido tem vários itens, pode ter mais de um pagamento e mais de uma entrega. Os arquivos de Primeiros passos continuam como estavam.

## Como gerar de novo

Os CSVs já vêm prontos. Se você mexer neles e quiser voltar ao original, rode nesta pasta:

```bash
python3 gerar.py
```

O gerador só usa a biblioteca padrão do Python e sempre produz os mesmos arquivos. A saída é:

```
clientes=120 produtos=30 pedidos=900 itens_pedido=1570 pagamentos=1040 entregas=1074
```

## Tabelas

| Tabela | Uma linha por | Chave | Colunas |
|---|---|---|---|
| `clientes` | cliente cadastrado | id_cliente | id_cliente, nome, cidade, uf, data_cadastro |
| `produtos` | produto do catálogo | id_produto | id_produto, nome, categoria, preco_lista |
| `pedidos` | pedido | id_pedido | id_pedido, id_cliente, data_hora_pedido, canal, status |
| `itens_pedido` | item de um pedido | id_pedido + n_item | id_pedido, n_item, id_produto, quantidade, preco_unitario, desconto |
| `pagamentos` | transação de pagamento | id_pagamento | id_pagamento, id_pedido, data_hora_pagamento, forma, valor, status |
| `entregas` | tentativa de entrega de um volume, ou a volta de uma devolução | id_entrega | id_entrega, id_pedido, volume, tentativa, tipo, transportadora, data_saida, data_tentativa, resultado, custo_frete |

O pedido não tem coluna de valor. O valor de um item é `quantidade * preco_unitario - desconto`, e o do pedido é a soma dos itens.

## Valores das colunas de código

| Coluna | Valores |
|---|---|
| `pedidos.status` | entregue, cancelado, devolvido, em_andamento |
| `pedidos.canal` | site, app, loja |
| `pagamentos.forma` | cartao, pix, boleto |
| `pagamentos.status` | aprovado, recusado, estornado, pendente |
| `entregas.tipo` | ida, devolucao |
| `entregas.resultado` | entregue, nao_encontrado, recebido_cd; vazio quando o volume ainda está na rua |

`desconto` vazio quer dizer que o item não teve cupom. `custo_frete` vazio quer dizer que a fatura da transportadora ainda não chegou.

Não edite os CSVs à mão para fazer um exercício. Se uma aula pedir uma mudança, ela diz qual.
