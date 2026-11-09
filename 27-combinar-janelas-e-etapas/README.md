# 27. Combinar janelas e etapas

Os arquivos da aula «Combinar janelas e etapas». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa do diagnóstico. |
| `historico.sql` | Os pagamentos de quatro pedidos, na ordem em que aconteceram. |
| `janela-no-where.sql` | A janela dentro do `WHERE`. O DuckDB recusa, e a aula mostra a mensagem. |
| `lista-do-caio.sql` | A lista do Caio: numera todos os pagamentos e filtra o aprovado depois da janela. |
| `ultimo-aprovado.sql` | O último pagamento aprovado de cada pedido, com o status filtrado antes da janela. |
| `quatro-pedidos.sql` | As duas listas lado a lado, para os quatro pedidos do histórico. |
| `comparar-as-listas.sql` | Quantos pedidos cada lista tem e quantos estão numa e não na outra. |
| `os-que-sumiram.sql` | Os pedidos que ficaram fora da lista do Caio, pelo último registro e pelo status do pedido. |
| `com-qualify.sql` | O último aprovado com `QUALIFY`, do DuckDB. |
| `lista-do-rafael.sql` | A lista completa: uma linha por pedido, com o último aprovado e a situação de hoje. |
| `amostra-da-lista.sql` | A mesma lista, com um filtro de sete pedidos na última etapa. |
| `checar-lista.sql` | Perguntas com resposta conhecida sobre a lista. |
| `pedido-dividido.sql` | O pedido 31, pago em duas partes. É o pedido 1 da prática. |
| `entregues-antes-e-depois.sql` | O filtro do pedido entregue antes e depois da janela. É o pedido 2 da prática. |
| `qualify-com-status.sql` | O status no `QUALIFY` em vez do `WHERE`. É o pedido 3 da prática. |
| `consulta-do-caio.sql` | A consulta do exercício, para você rodar antes de corrigir. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo historico.sql
python3 consultar.py --dados ../dados --arquivo janela-no-where.sql
python3 consultar.py --dados ../dados --arquivo lista-do-caio.sql
python3 consultar.py --dados ../dados --arquivo ultimo-aprovado.sql
python3 consultar.py --dados ../dados --arquivo quatro-pedidos.sql
python3 consultar.py --dados ../dados --arquivo comparar-as-listas.sql
python3 consultar.py --dados ../dados --arquivo os-que-sumiram.sql
python3 consultar.py --dados ../dados --arquivo com-qualify.sql
python3 consultar.py --dados ../dados --arquivo lista-do-rafael.sql
python3 consultar.py --dados ../dados --arquivo amostra-da-lista.sql
python3 consultar.py --dados ../dados --arquivo checar-lista.sql
python3 consultar.py --dados ../dados --arquivo pedido-dividido.sql
python3 consultar.py --dados ../dados --arquivo entregues-antes-e-depois.sql
python3 consultar.py --dados ../dados --arquivo qualify-com-status.sql
python3 consultar.py --dados ../dados --arquivo consulta-do-caio.sql
python3 consultar.py --dados ../dados --arquivo minhas-consultas.sql
```

O `janela-no-where.sql` não roda de propósito: o programa imprime `A consulta não rodou` e a mensagem `WHERE clause cannot contain window functions!`. O `lista-do-caio.sql` termina com `(777 linhas)`, e o `ultimo-aprovado.sql` e o `com-qualify.sql` com `(869 linhas)`. O `lista-do-rafael.sql` tem `900` linhas, uma por pedido.

As listas e a consulta do Caio imprimem muitas linhas. Se quiser olhar só alguns pedidos, copie a consulta para o `minhas-consultas.sql` e acrescente o filtro numa etapa depois da janela, como no `amostra-da-lista.sql`.

Enquanto o `minhas-consultas.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Deixe uma consulta por vez no arquivo: se houver duas, o programa mostra só o resultado da última.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
