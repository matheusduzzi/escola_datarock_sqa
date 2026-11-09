# 25. Acumulado e participação

Os arquivos da aula «Acumulado e participação». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa do diagnóstico. |
| `vendas.sql` | O faturamento de cada categoria em cada mês, sem pedido cancelado. A tabela de partida. |
| `acumulado-sem-particao.sql` | A primeira tentativa de acumulado: `ORDER BY mes` sem `PARTITION BY`. Mostra janeiro e fevereiro. |
| `acumulado-por-categoria.sql` | O acumulado de cada categoria, com `PARTITION BY categoria`. Mostra Eletro e Esporte. |
| `fecha-com-o-total.sql` | O último acumulado de cada categoria ao lado do total da categoria calculado sem janela. |
| `participacao-do-semestre.sql` | A participação dividida pelo total do semestre, somada mês a mês. |
| `participacao-no-mes.sql` | A participação de cada categoria no total do mês. Mostra janeiro e abril. |
| `prova.sql` | As checagens da consulta certa e da primeira tentativa, lado a lado. |
| `filtro-antes-da-janela.sql` | A participação de Eletro com o `WHERE` antes da janela e com o filtro numa etapa depois. |
| `empate-no-dia.sql` | Pedidos acumulados por dia, com o frame padrão e com `ROWS` e desempate. |
| `esporte-com-calendario.sql` | Esporte mês a mês com a tabela de meses. É o pedido 1 da prática. |
| `media-de-participacoes.sql` | A média das participações mensais contra a participação no semestre. É o pedido 3 da prática. |
| `consulta-do-caio.sql` | A consulta do exercício, para você rodar antes de corrigir. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo vendas.sql
python3 consultar.py --dados ../dados --arquivo acumulado-sem-particao.sql
python3 consultar.py --dados ../dados --arquivo acumulado-por-categoria.sql
python3 consultar.py --dados ../dados --arquivo fecha-com-o-total.sql
python3 consultar.py --dados ../dados --arquivo participacao-do-semestre.sql
python3 consultar.py --dados ../dados --arquivo participacao-no-mes.sql
python3 consultar.py --dados ../dados --arquivo prova.sql
python3 consultar.py --dados ../dados --arquivo filtro-antes-da-janela.sql
python3 consultar.py --dados ../dados --arquivo empate-no-dia.sql
python3 consultar.py --dados ../dados --arquivo esporte-com-calendario.sql
python3 consultar.py --dados ../dados --arquivo media-de-participacoes.sql
python3 consultar.py --dados ../dados --arquivo consulta-do-caio.sql
python3 consultar.py --dados ../dados --arquivo minhas-consultas.sql
```

O `prova.sql` mostra `5` na primeira linha da coluna `certa` e `0` na coluna `primeira`. O `fecha-com-o-total.sql` mostra `0.00` na coluna `diferenca` das cinco categorias.

Enquanto o `minhas-consultas.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Deixe uma consulta por vez no arquivo: se houver duas, o programa mostra só o resultado da última.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
