# 26. Média móvel com calendário

Os arquivos da aula «Média móvel com calendário». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa do diagnóstico. |
| `media-do-caio.sql` | A média de 3 meses do Caio, com `ROWS` sobre os pedidos agrupados por mês e categoria. Mostra Esporte. |
| `meses-da-janela.sql` | A janela do Caio em Esporte: o primeiro e o último mês de cada janela e quantos meses do calendário ela cobre. |
| `janela-por-range.sql` | A mesma média com `RANGE` de 2 meses, sem tabela de meses. |
| `media-com-calendario.sql` | A média de 3 meses sobre a série completa da aula 19, com o zero de abril. |
| `por-dia.sql` | Esporte com os dias da base em cada janela, a média por mês e os pedidos por dia. |
| `indicador.sql` | O indicador da reunião: média de 3 meses por categoria, com a situação de cada janela. |
| `checar-indicador.sql` | Perguntas com resposta conhecida sobre o indicador. |
| `janela-de-junho.sql` | Os meses que entraram na média de junho de Esporte, na consulta do Caio e na série completa. É o pedido 1 da prática. |
| `loja-toda.sql` | A média de 3 meses da loja inteira, sem e com calendário. É o pedido 2 da prática. |
| `janela-centrada.sql` | A média de 3 meses com o mês no meio da janela. É o pedido 3 da prática. |
| `consulta-do-caio.sql` | A consulta do exercício, para você rodar antes de corrigir. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo media-do-caio.sql
python3 consultar.py --dados ../dados --arquivo meses-da-janela.sql
python3 consultar.py --dados ../dados --arquivo janela-por-range.sql
python3 consultar.py --dados ../dados --arquivo media-com-calendario.sql
python3 consultar.py --dados ../dados --arquivo por-dia.sql
python3 consultar.py --dados ../dados --arquivo indicador.sql
python3 consultar.py --dados ../dados --arquivo checar-indicador.sql
python3 consultar.py --dados ../dados --arquivo janela-de-junho.sql
python3 consultar.py --dados ../dados --arquivo loja-toda.sql
python3 consultar.py --dados ../dados --arquivo janela-centrada.sql
python3 consultar.py --dados ../dados --arquivo consulta-do-caio.sql
python3 consultar.py --dados ../dados --arquivo minhas-consultas.sql
```

O `media-com-calendario.sql` mostra `0` pedidos de Esporte em abril e `34.0` na média de maio. O `indicador.sql` tem `30` linhas, com janeiro e fevereiro como `inicial` e junho como `parcial`.

O `consulta-do-caio.sql` imprime uma linha por dia que teve viagem, e são muitas. Se quiser olhar só um trecho, copie a consulta para o `minhas-consultas.sql` e acrescente um filtro numa etapa depois da janela.

Enquanto o `minhas-consultas.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Deixe uma consulta por vez no arquivo: se houver duas, o programa mostra só o resultado da última.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
