# 24. ROWS, RANGE e fronteiras

Os arquivos da aula «ROWS, RANGE e fronteiras». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa do diagnóstico. |
| `pedidos-por-dia.sql` | Os pedidos de cada dia, de 1º a 21 de janeiro, sem pedido cancelado. A tabela de partida, sem janela. |
| `janela-do-caio.sql` | A primeira tentativa: `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW` sobre uma linha por pedido. Mostra os dias 7 e 8. |
| `intervalo-de-7-dias.sql` | A segunda tentativa: `RANGE` com `INTERVAL 7 DAYS PRECEDING`, com o primeiro e o último dia da janela. Mostra os dias 7 a 10. |
| `ultimos-7-dias.sql` | A janela certa, com `INTERVAL 6 DAYS PRECEDING`. Uma linha por dia, de 1º a 21 de janeiro. |
| `groups-e-dia-sem-pedido.sql` | `RANGE` e `GROUPS` lado a lado, de 14 a 21 de janeiro. O dia 15 não tem pedido. |
| `prova.sql` | As quatro versões da janela contra a conta sem janela, em todos os dias do semestre. |
| `janela-com-hora.sql` | A janela de 6 dias ordenando pela data e hora do pedido. É o pedido 2 da prática. |
| `range-com-desempate.sql` | `RANGE` com intervalo e duas colunas na ordem. Dá erro de propósito. É o pedido 3 da prática. |
| `ultimo-pedido-do-dia.sql` | `LAST_VALUE` com o frame padrão e com o frame até o fim do dia. |
| `unidades-por-dia.sql` | Pedidos e unidades de cada dia, de 10 a 21 de janeiro. A tabela do exercício. |
| `consulta-do-caio.sql` | A consulta do exercício, para você rodar antes de corrigir. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo pedidos-por-dia.sql
python3 consultar.py --dados ../dados --arquivo janela-do-caio.sql
python3 consultar.py --dados ../dados --arquivo intervalo-de-7-dias.sql
python3 consultar.py --dados ../dados --arquivo ultimos-7-dias.sql
python3 consultar.py --dados ../dados --arquivo groups-e-dia-sem-pedido.sql
python3 consultar.py --dados ../dados --arquivo prova.sql
python3 consultar.py --dados ../dados --arquivo janela-com-hora.sql
python3 consultar.py --dados ../dados --arquivo range-com-desempate.sql
python3 consultar.py --dados ../dados --arquivo ultimo-pedido-do-dia.sql
python3 consultar.py --dados ../dados --arquivo unidades-por-dia.sql
python3 consultar.py --dados ../dados --arquivo consulta-do-caio.sql
python3 consultar.py --dados ../dados --arquivo minhas-consultas.sql
```

O `prova.sql` mostra `170` na primeira linha das colunas `esperado` e `certa`. O `range-com-desempate.sql` termina com `A consulta não rodou` e a mensagem do DuckDB: é o erro que a aula mostra.

Enquanto o `minhas-consultas.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Deixe uma consulta por vez no arquivo: se houver duas, o programa mostra só o resultado da última.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
