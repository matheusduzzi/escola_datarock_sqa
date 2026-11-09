# Mapa de chaves e cardinalidades da Loja Exemplo

Nome:

As linhas de `pedidos`, `itens_pedido` e `entregas` vêm da aula. Preencha as outras e cole embaixo de cada parte a consulta e a saída que mostram o número.

## As tabelas

| Tabela | Uma linha é | Chave | Teste da chave (linhas e diferentes) | Aponta para |
|---|---|---|---|---|
| `pedidos` | um pedido | `id_pedido` | 900 linhas, 900 diferentes | `clientes` pelo `id_cliente` |
| `itens_pedido` | um produto dentro de um pedido | `id_pedido + n_item` | 1.570 linhas, 1.570 diferentes | `pedidos` e `produtos` |
| `entregas` | uma tentativa de um volume, ou a volta de uma devolução | `id_pedido + tipo + volume + tentativa` (o sistema usa `id_entrega`) | 1.074 linhas, 1.074 diferentes; sem o `tipo`, 1.024 | `pedidos` |
| `pagamentos` | | | | |
| `clientes` | | | | |
| `produtos` | | | | |

O `id_pedido` sozinho poderia ser a chave de `pagamentos`? Por quê, com o número:

Consultas e saídas:

```sql

```

## As ligações

| Relação | Cada pai tem | Cada filho tem | O que apareceu (mínimo, máximo, pais sem filho) | Órfãos |
|---|---|---|---|---|
| pedido para itens | 1 a N itens | exatamente 1 pedido | de 1 a 4; nenhum pedido sem item | 0 |
| pedido para entregas | 0 a N entregas | exatamente 1 pedido | de 0 a 4; 71 sem entrega, todos cancelados | 0 |
| pedido para volumes | 0 a N volumes | exatamente 1 pedido | de 0 a 2 | 0 |
| volume para tentativas | 1 a N tentativas | exatamente 1 volume | de 1 a 3 | 0 |
| cliente para pedidos | | | | |
| produto para itens | | | | |
| pedido para pagamentos | | | | |

Quem são os pais sem filho e se isso é esperado:

Consultas e saídas:

```sql

```

## A consulta do Caio

Por que o valor saiu R$ 486.039,62:

Minha previsão para o pedido 32 (linhas e valor pago somado), antes de rodar:

O que saiu quando rodei:

Minha consulta com uma linha por pedido, a saída e o total da tabela `pagamentos` para comparar:

```sql

```
