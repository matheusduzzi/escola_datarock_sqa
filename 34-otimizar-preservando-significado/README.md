# 34. Otimizar sem mudar o resultado

Os arquivos da aula «Otimizar sem mudar o resultado». Rode os comandos de dentro desta pasta. O `consultar.py`, o `plano.py` e o `medir.py` leem a base da Loja Exemplo em `../dados` (o dicionário está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md)), mas as consultas dessa aula usam o histórico que o `montar.py` cria.

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O histórico

É o mesmo da aula 33, «Investigar desempenho com EXPLAIN». O `montar.py --milhoes 3` cria, nesta pasta, o arquivo `historico.duckdb` (cerca de 75 MB) e a pasta `historico_por_mes/` (cerca de 42 MB), em alguns segundos. O período vai de dezembro de 2021 a junho de 2026. Os valores saem de uma regra fixa e não são vendas de verdade: o que interessa aqui é o volume. Rodar de novo apaga e monta tudo do zero.

As consultas dessa aula leem a tabela `itens_historico`, os itens na ordem da carga. Cada linha é um item, com `id_item`, `id_pedido`, `id_cliente`, `data_hora_pedido`, `canal`, `categoria` e `valor`.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `montar.py` | Cria o histórico. O mesmo da aula 33. Rode antes de tudo. |
| `medir.py` | Mede o tempo da última consulta de um arquivo `.sql` e mostra a configuração, o volume e a impressão digital do resultado. Com `--perfil`, mostra o tempo de cada operador. O mesmo da aula 33. |
| `plano.py` | Mostra o plano da consulta. Com `--real`, a consulta roda e aparecem as linhas reais de cada operador. O mesmo da aula 33. |
| `relatorio-do-caio.sql` | O relatório do mês por canal como o Caio escreveu. |
| `relatorio-da-ia.sql` | A versão que a IA mandou. |
| `comparar-com-a-ia.sql` | As linhas que só uma das duas tem, com `EXCEPT ALL` nos dois sentidos. |
| `uma-mudanca-por-vez.sql` | Cada mudança da IA sozinha sobre a consulta do Caio, e a comparação de cada uma com a original. |
| `relatorio-revisado.sql` | O relatório depois da revisão. |
| `comparar-com-a-revisada.sql` | A prova da revisada: contagens e `EXCEPT ALL` nos dois sentidos. |
| `sem-a-cte.sql` | Outra reescrita, sem a etapa por pedido. |
| `premissas-sem-a-cte.sql` | Conta no histórico as duas premissas de que a versão sem a CTE precisa. |
| `sem-order-by.sql` | A revisada sem o `ORDER BY`. É o pedido 1 da prática. |
| `except-sem-all.sql` | `EXCEPT` e `EXCEPT ALL` em duas listas pequenas. É o pedido 2 da prática. |
| `sem-a-cte-nos-casos-de-fronteira.sql` | As duas versões sobre itens escritos à mão. É o pedido 3 da prática. |
| `presentes-do-caio.sql` | O relatório de Presentes do exercício, como o Caio escreveu. |
| `presentes-da-ia.sql` | A versão da IA do relatório de Presentes. |
| `modelo-de-prova.md` | O formato da consulta de comparação e as perguntas antes de dizer que duas versões retornam o mesmo. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

Na ordem da aula:

```bash
python3 montar.py --milhoes 3
python3 consultar.py --dados ../dados --arquivo relatorio-do-caio.sql
python3 consultar.py --dados ../dados --arquivo relatorio-da-ia.sql
python3 consultar.py --dados ../dados --arquivo comparar-com-a-ia.sql
python3 consultar.py --dados ../dados --arquivo uma-mudanca-por-vez.sql
python3 consultar.py --dados ../dados --arquivo relatorio-revisado.sql
python3 consultar.py --dados ../dados --arquivo comparar-com-a-revisada.sql
python3 medir.py --dados ../dados --arquivo relatorio-do-caio.sql
python3 medir.py --dados ../dados --arquivo relatorio-revisado.sql
python3 medir.py --dados ../dados --arquivo sem-a-cte.sql
python3 plano.py --dados ../dados --arquivo relatorio-do-caio.sql --real
python3 plano.py --dados ../dados --arquivo relatorio-revisado.sql --real
python3 medir.py --dados ../dados --arquivo relatorio-do-caio.sql --perfil
python3 medir.py --dados ../dados --arquivo relatorio-revisado.sql --perfil
python3 consultar.py --dados ../dados --arquivo premissas-sem-a-cte.sql
```

A prática guiada:

```bash
python3 medir.py --dados ../dados --arquivo sem-order-by.sql --threads 1
python3 medir.py --dados ../dados --arquivo sem-order-by.sql
python3 medir.py --dados ../dados --arquivo sem-order-by.sql --threads 8
python3 consultar.py --dados ../dados --arquivo except-sem-all.sql
python3 consultar.py --dados ../dados --arquivo sem-a-cte-nos-casos-de-fronteira.sql
```

O exercício:

```bash
python3 consultar.py --dados ../dados --arquivo presentes-do-caio.sql
python3 consultar.py --dados ../dados --arquivo presentes-da-ia.sql
python3 consultar.py --dados ../dados --arquivo minhas-consultas.sql
python3 medir.py --dados ../dados --arquivo minhas-consultas.sql
```

O `comparar-com-a-revisada.sql` termina com `só na do Caio 0` e `só na revisada 0`. O `comparar-com-a-ia.sql` mostra 6 linhas, 3 de cada lado.

Os tempos do `medir.py` são da sua máquina e mudam a cada execução. Os resultados e as impressões digitais das consultas com `ORDER BY` são os mesmos em qualquer máquina. As do `sem-order-by.sql` podem mudar com o número de threads: é o que o pedido 1 mostra.

Enquanto o `minhas-consultas.sql` só tiver comentários, o `consultar.py` avisa `O arquivo ainda não tem consulta` e não roda nada. Deixe uma consulta por vez no arquivo (o `ATTACH` pode ficar): o `consultar.py` mostra o resultado da última, e o `medir.py` mede a última.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
