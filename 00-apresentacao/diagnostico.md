# Por onde começar: o diagnóstico de SQL

São quatro tarefas curtas sobre os pedidos de março da Loja Exemplo. Cada uma testa um fundamento que o curso usa desde a primeira prática: filtro com valor vazio, agregação, JOIN que multiplica linhas e a checagem de um resultado antes de entregar.

O diagnóstico não é prova de entrada e não tem nota. Ele mostra onde você está firme e o que vale revisar antes da aula 01. Faça sem consultar a resposta. Se travar, anote onde travou: isso também é resposta.

## Como rodar

Na pasta dessa aula do kit, a `00-apresentacao/`, rode:

```bash
python3 consultar.py --sql "SELECT * FROM pedidos"
```

Você vê 16 pedidos e `(16 linhas)` no fim. Cada tarefa tem um arquivo em branco em `respostas/`. Escreva a consulta nele e rode:

```bash
python3 consultar.py --arquivo respostas/tarefa-1.sql
```

As três tabelas estão em `dados/`:

| Tabela | Uma linha por | Colunas |
|---|---|---|
| `clientes` | cliente cadastrado | id_cliente, nome, cidade |
| `pedidos` | pedido | id_pedido, id_cliente, data_pedido, status, valor, cupom |
| `entregas` | tentativa de entrega | id_entrega, id_pedido, tentativa, resultado, custo_frete |

`valor` vazio quer dizer que o valor do pedido não foi lançado no caixa. `cupom` vazio quer dizer que o cliente não usou cupom. Todos os pedidos são de março de 2026.

As respostas em texto vão em [minhas-respostas.md](minhas-respostas.md).

## Tarefa 1: quem não usou o cupom

A Bia, do marketing, vai mandar um cupom novo só para quem comprou em março sem usar o cupom VERAO. Ela me pediu a lista dos pedidos entregues de março que não usaram o VERAO.

Escreva a consulta em `respostas/tarefa-1.sql`. Anote em `minhas-respostas.md` quantos pedidos saíram e por que o pedido 102 entra ou não entra na lista.

## Tarefa 2: faturamento por cupom

O Rafael, do financeiro, quer saber quanto cada cupom trouxe. Ele pediu uma linha por cupom e uma linha para quem não usou cupom. Em cada linha, o número de pedidos entregues e o faturamento. Ele só quer ver os grupos que faturaram mais de R$ 200.

Escreva a consulta em `respostas/tarefa-2.sql`. Anote quantos pedidos entregues estão sem valor e como eles aparecem no seu resultado: entram na contagem? entram na soma?

## Tarefa 3: frete sobre o faturamento

A Marta, da logística, quer saber quanto o frete pesou em março. Ela pediu três números: o faturamento dos pedidos entregues, o custo total de frete e o frete como percentual do faturamento, com uma casa decimal.

Repare que um pedido pode ter mais de uma tentativa de entrega, e cada tentativa tem o seu custo.

Escreva a consulta em `respostas/tarefa-3.sql` e anote os três números.

## Tarefa 4: antes de mandar para a gerente

O Léo, que trabalha comigo, montou o relatório de março por cidade. Ele me pediu para dar uma olhada antes de mandar para a gerente. A mensagem dele dizia: "13 clientes compraram em março e o faturamento foi de R$ 1.525,00". A consulta que ele usou já está em `respostas/tarefa-4.sql`.

Rode a consulta do Léo. Depois diga, em `minhas-respostas.md`:

1. quais checagens você fez e o que cada uma mostrou;
2. o que está errado na mensagem dele, se algo estiver;
3. a consulta corrigida, no mesmo arquivo `respostas/tarefa-4.sql`, e os números que você mandaria no lugar dos dele.

## Depois de terminar

Compare com as respostas comentadas na página da aula 00. Cada tarefa indica a aula de Primeiros passos em dados: SQL e Python que treina aquele fundamento. Se uma tarefa ficou difícil, estude a aula indicada e refaça a tarefa antes de seguir.
