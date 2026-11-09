# Folha do exercício: o sorteio da Bruna

Salve uma cópia com o seu nome. Preencha a tarefa 1 antes de rodar o `previsoes.sql`.

## Tarefa 1. A previsão

As listas: `app` é `SELECT id_cliente FROM inscricoes_app` e `loja` é `SELECT id_cliente FROM inscricoes_loja`.

Primeiro a tabela de m e n (m = vezes no app, n = vezes na loja):

| id_cliente | m (app) | n (loja) |
|---|---|---|
| | | |

Depois as sete consultas:

| Consulta | Operação | Linhas que eu espero | Ids que eu espero (com repetição) | Depois de rodar: bateu? | Se não bateu, por quê |
|---|---|---|---|---|---|
| C1 | `app UNION ALL loja` | | | | |
| C2 | `app UNION loja` | | | | |
| C3 | `app INTERSECT loja` | | | | |
| C4 | `app INTERSECT ALL loja` | | | | |
| C5 | `app EXCEPT loja` | | | | |
| C6 | `app EXCEPT ALL loja` | | | | |
| C7 | `loja EXCEPT ALL app` | | | | |

## Tarefa 2. As consultas da Bruna

| Regra | Operação que eu usei | Por quê | Resultado do `sorteio.sql` |
|---|---|---|---|
| Números do sorteio, sem funcionário | | | |
| Brinde, um por cliente, sem funcionário | | | |
| Cupom extra, dois canais, sem funcionário | | | |

## Tarefa 3. O funcionário

| Tentativa | Números que deu | O que fez com o funcionário | O que fez com quem não é funcionário |
|---|---|---|---|
| `UNION ALL` e depois `EXCEPT funcionarios` | | | |
| `UNION ALL` e depois `EXCEPT ALL funcionarios` | | | |
| A minha consulta da tarefa 2 | | | |
