# 16. Datas, períodos e limites

Os arquivos da aula «Datas, períodos e limites». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa do diagnóstico. |
| `mes-com-between.sql` | Pedidos e valor por mês com `BETWEEN` do dia 1 ao último dia. A primeira tentativa da aula. |
| `meia-noite.sql` | Mostra que uma data sem hora vira meia-noite quando é comparada com data e hora. |
| `between-ate-o-dia-1.sql` | Pedidos e valor por mês com `BETWEEN` do dia 1 ao dia 1 do mês seguinte. A segunda tentativa. |
| `viradas.sql` | Os pedidos da última hora de um mês e da primeira do seguinte, e em quantos meses cada um entra em cada forma. |
| `meio-aberto.sql` | Pedidos e valor por mês com o começo que entra e o fim que não entra, e a tabela de meses gerada pelo `range`. |
| `prova.sql` | Em quantos meses cada pedido entrou, nas três formas: soma dos meses, pedidos em nenhum mês e em dois. |
| `fracao-de-segundo.sql` | Três instantes perto da virada de abril, com o fim em 23:59:59 e com o meio aberto. |
| `texto-na-tabela.sql` | A tabela de meses com datas escritas como texto. Termina com a mensagem de erro do DuckDB, de propósito. |
| `data-do-pagamento.sql` | Pedidos com pagamento aprovado num mês diferente do mês do pedido. |
| `fim-da-base.sql` | O primeiro e o último pedido da base. |
| `ultimo-dia.sql` | Os pedidos de 31 de março: à meia-noite e no dia todo. É o pedido 1 da prática. |
| `trimestre.sql` | O primeiro trimestre num número só, com `BETWEEN` e com o meio aberto. É o pedido 3 da prática. |
| `consulta-do-caio.sql` | A consulta do exercício, para você rodar antes de corrigir. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo mes-com-between.sql
python3 consultar.py --dados ../dados --arquivo meia-noite.sql
python3 consultar.py --dados ../dados --arquivo between-ate-o-dia-1.sql
python3 consultar.py --dados ../dados --arquivo viradas.sql
python3 consultar.py --dados ../dados --arquivo meio-aberto.sql
python3 consultar.py --dados ../dados --arquivo prova.sql
python3 consultar.py --dados ../dados --arquivo fracao-de-segundo.sql
python3 consultar.py --dados ../dados --arquivo texto-na-tabela.sql
python3 consultar.py --dados ../dados --arquivo data-do-pagamento.sql
python3 consultar.py --dados ../dados --arquivo fim-da-base.sql
python3 consultar.py --dados ../dados --arquivo ultimo-dia.sql
python3 consultar.py --dados ../dados --arquivo trimestre.sql
python3 consultar.py --dados ../dados --arquivo consulta-do-caio.sql
python3 consultar.py --dados ../dados --arquivo minhas-consultas.sql
```

O `prova.sql` termina com a linha `meio aberto`: `900` pedidos na base, `900` na soma dos meses, `0` em nenhum mês e `0` em dois. O `meio-aberto.sql` mostra `166` pedidos em março.

O `texto-na-tabela.sql` não roda: o programa mostra `A consulta não rodou` e a mensagem `Cannot compare values of type TIMESTAMP and type VARCHAR`. É o que a aula quer mostrar.

Enquanto o `minhas-consultas.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Deixe uma consulta por vez no arquivo: se houver duas, o programa mostra só o resultado da última.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
