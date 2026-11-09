# 21. Partição, ordenação e frame

Os arquivos da aula «Partição, ordenação e frame». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa do diagnóstico. |
| `pedidos-2-e-3.sql` | Os dez pedidos de 2 e 3 de janeiro, um por linha, com hora, canal e unidades. A tabela de partida da aula. |
| `total-por-dia.sql` | O total de pedidos e de unidades por dia, com `GROUP BY`. Sai uma linha por dia. |
| `total-do-dia-ao-lado.sql` | O mesmo total, com janela e `PARTITION BY dia`. Cada pedido fica na sua linha. |
| `janela-sem-particao.sql` | A janela com `OVER ()` vazio: o total dos dois dias em todas as linhas. |
| `acumulado-no-dia.sql` | O acumulado de unidades no dia, com `ORDER BY hora` dentro do `OVER`. |
| `ordem-por-dia.sql` | A soma com `ORDER BY dia` e sem partição: os pedidos do mesmo dia empatam. |
| `frame-escrito.sql` | O frame padrão, o mesmo frame escrito por extenso e o frame com a linha anterior. |
| `janela-no-where.sql` | Uma janela no `WHERE`. Dá erro de propósito. |
| `ordem-final.sql` | O acumulado do dia com outra ordem no fim da consulta. |
| `canal-agrupado.sql` | Pedido 1 da prática: pedidos e unidades por canal, com `GROUP BY`. |
| `canal-ao-lado.sql` | Pedido 1 da prática: as mesmas contas por canal, com janela. |
| `menor-ate-aqui.sql` | Pedido 2 da prática: o menor pedido do dia até a linha atual. |
| `ordem-por-canal.sql` | Pedido 3 da prática: a soma com `ORDER BY canal` e sem partição. |
| `dia-6.sql` | A tabela de partida do exercício: os dez pedidos de 6 de janeiro. |
| `ex1-agrupado.sql` | Consulta 1 do exercício. Preveja antes de rodar. |
| `ex2-ao-lado.sql` | Consulta 2 do exercício. Preveja antes de rodar. |
| `ex3-acumulado-do-dia.sql` | Consulta 3 do exercício. Preveja antes de rodar. |
| `ex4-com-o-anterior.sql` | Consulta 4 do exercício. Preveja antes de rodar. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para a sua consulta da tarefa 3. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo pedidos-2-e-3.sql
python3 consultar.py --dados ../dados --arquivo total-por-dia.sql
python3 consultar.py --dados ../dados --arquivo total-do-dia-ao-lado.sql
python3 consultar.py --dados ../dados --arquivo janela-sem-particao.sql
python3 consultar.py --dados ../dados --arquivo acumulado-no-dia.sql
python3 consultar.py --dados ../dados --arquivo ordem-por-dia.sql
python3 consultar.py --dados ../dados --arquivo frame-escrito.sql
python3 consultar.py --dados ../dados --arquivo janela-no-where.sql
python3 consultar.py --dados ../dados --arquivo ordem-final.sql
python3 consultar.py --dados ../dados --arquivo canal-agrupado.sql
python3 consultar.py --dados ../dados --arquivo canal-ao-lado.sql
python3 consultar.py --dados ../dados --arquivo menor-ate-aqui.sql
python3 consultar.py --dados ../dados --arquivo ordem-por-canal.sql
python3 consultar.py --dados ../dados --arquivo dia-6.sql
python3 consultar.py --dados ../dados --arquivo ex1-agrupado.sql
python3 consultar.py --dados ../dados --arquivo ex2-ao-lado.sql
python3 consultar.py --dados ../dados --arquivo ex3-acumulado-do-dia.sql
python3 consultar.py --dados ../dados --arquivo ex4-com-o-anterior.sql
python3 consultar.py --dados ../dados --arquivo minhas-consultas.sql
```

O `total-por-dia.sql` mostra `(2 linhas)` no fim e o `total-do-dia-ao-lado.sql` mostra `(10 linhas)`.

O `janela-no-where.sql` não roda: o programa mostra `A consulta não rodou` e a mensagem do DuckDB, `WHERE clause cannot contain window functions!`. É esse o resultado esperado.

Enquanto o `minhas-consultas.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Deixe uma consulta por vez no arquivo: se houver duas, o programa mostra só o resultado da última.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
