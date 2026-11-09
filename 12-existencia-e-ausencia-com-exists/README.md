# 12. Encontrar registros com EXISTS

Os arquivos da aula «Encontrar registros com EXISTS». Rode os comandos de dentro desta pasta. Os clientes, os pedidos e as entregas vêm da base da Loja Exemplo, em `../dados`; o dicionário está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md). Os dois arquivos exportados pela ferramenta de e-mail ficam em `dados/`, nesta pasta.

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `dados/descadastros.csv` | Quem pediu para não receber e-mail: data, cliente e canal. Duas linhas vieram sem cliente. |
| `dados/respostas_pesquisa.csv` | As respostas da pesquisa de entrega de maio: data, cliente e nota. É o arquivo do exercício. |
| `primeira-tentativa.sql` | A primeira tentativa da aula: JOIN de clientes com pedidos e filtro no status. Conta linhas e clientes. |
| `um-cliente.sql` | Os clientes 47 e 61 na primeira tentativa: quantas vezes aparecem e quantos pedidos de cada status têm. É o pedido 1 da prática. |
| `com-exists.sql` | Clientes com pelo menos um pedido entregue, com `EXISTS`. |
| `elegiveis.sql` | Clientes com pedido entregue e sem devolução, com `EXISTS` e `NOT EXISTS`. |
| `com-join.sql` | A mesma lista só com JOIN e `LEFT JOIN` com `IS NULL`. |
| `comparar.sql` | As listas do `EXISTS` e do JOIN lado a lado, com `EXCEPT` nos dois sentidos. |
| `com-ultimo-pedido.sql` | A lista com a data do último pedido entregue, com os pedidos reduzidos a uma linha por cliente antes do JOIN. |
| `descadastros.sql` | Lê a lista de descadastro como chegou. |
| `not-in.sql` | A lista sem os descadastros, com `NOT IN`. Sai vazia, de propósito. |
| `tres-valores.sql` | O que `IN` e `NOT IN` respondem quando a lista tem NULL. |
| `lista-da-bruna.sql` | A lista final, com `NOT EXISTS`: uma linha por cliente. |
| `prova.sql` | A prova da lista por outro caminho: linhas, clientes, quem quebra cada regra e o total pela contagem por cliente. |
| `sem-ligacao.sql` | Um `EXISTS` sem a ligação com o cliente de fora. |
| `so-descadastrados.sql` | Quantos dos 70 pediram para sair, com `IN` e com JOIN. É o pedido 2 da prática. |
| `nunca-compraram.sql` | Clientes sem pedido, com `NOT EXISTS` e com `LEFT JOIN`. É o pedido 3 da prática. |
| `consulta-do-caio.sql` | A consulta do exercício, para você rodar antes de corrigir. |
| `respostas.sql` | Lê as respostas da pesquisa de maio como chegaram. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo primeira-tentativa.sql
python3 consultar.py --dados ../dados --arquivo um-cliente.sql
python3 consultar.py --dados ../dados --arquivo com-exists.sql
python3 consultar.py --dados ../dados --arquivo elegiveis.sql
python3 consultar.py --dados ../dados --arquivo com-join.sql
python3 consultar.py --dados ../dados --arquivo comparar.sql
python3 consultar.py --dados ../dados --arquivo com-ultimo-pedido.sql
python3 consultar.py --dados ../dados --arquivo descadastros.sql
python3 consultar.py --dados ../dados --arquivo not-in.sql
python3 consultar.py --dados ../dados --arquivo tres-valores.sql
python3 consultar.py --dados ../dados --arquivo lista-da-bruna.sql
python3 consultar.py --dados ../dados --arquivo prova.sql
python3 consultar.py --dados ../dados --arquivo sem-ligacao.sql
python3 consultar.py --dados ../dados --arquivo so-descadastrados.sql
python3 consultar.py --dados ../dados --arquivo nunca-compraram.sql
python3 consultar.py --dados ../dados --arquivo consulta-do-caio.sql
python3 consultar.py --dados ../dados --arquivo respostas.sql
python3 consultar.py --dados ../dados --arquivo minhas-consultas.sql
```

O `elegiveis.sql` mostra `70` linhas e `70` clientes. O `lista-da-bruna.sql` termina com `(64 linhas)`. O `prova.sql` mostra `64`, `64`, três zeros e `64`.

O `not-in.sql` e o `consulta-do-caio.sql` rodam sem erro e mostram só o cabeçalho e `(0 linhas)`. É o que a aula e o exercício querem mostrar.

As consultas que leem `dados/descadastros.csv` ou `dados/respostas_pesquisa.csv` precisam ser rodadas de dentro desta pasta, porque o caminho do arquivo parte dela.

Enquanto o `minhas-consultas.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Deixe uma consulta por vez no arquivo: se houver duas, o programa mostra só o resultado da última. Um `CREATE VIEW` seguido de um `SELECT` conta como uma consulta.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
