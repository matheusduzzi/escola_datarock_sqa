# 23. Comparar linhas com LAG e LEAD

Os arquivos da aula «Comparar linhas com LAG e LEAD». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `variacao-do-caio.sql` | A consulta do Caio: pedidos por mês com `GROUP BY` e o `LAG` ao lado, só Esporte. |
| `linha-anterior.sql` | A mesma série, com o mês da linha de cima (`LAG`), o da linha de baixo (`LEAD`) e a distância em meses. |
| `pedido-anterior.sql` | As compras do cliente 11, com a compra anterior e a próxima. |
| `variacao-na-grade.sql` | O `LAG` do Caio em cima da série completa da aula 19, só Esporte. |
| `divisao-por-zero.sql` | O que o DuckDB retorna quando a conta divide por zero. |
| `lag-com-padrao.sql` | O `LAG` com 0 no lugar do NULL, em janeiro. É o pedido 2 da prática. |
| `variacao-mensal.sql` | A variação da reunião: uma linha por mês e categoria, com o anterior, a diferença, o percentual e a leitura. |
| `checar-variacao.sql` | Perguntas sobre a variação, com a resposta de cada uma. |
| `junho-por-dia.sql` | Esporte em maio e junho, com os pedidos por dia que a base cobre. É a pergunta 2 da aula. |
| `briefing-diario.md` | O pedido da Lúcia para o exercício: Esporte dia a dia e as três perguntas. |
| `diario-do-caio.sql` | A consulta do Caio para o pedido do exercício. |
| `minha-consulta.sql` | Um arquivo em branco para a sua consulta. |
| `minhas-respostas.md` | A folha do exercício. Salve uma cópia com o seu nome. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo variacao-do-caio.sql
python3 consultar.py --dados ../dados --arquivo linha-anterior.sql
python3 consultar.py --dados ../dados --arquivo pedido-anterior.sql
python3 consultar.py --dados ../dados --arquivo variacao-na-grade.sql
python3 consultar.py --dados ../dados --arquivo divisao-por-zero.sql
python3 consultar.py --dados ../dados --arquivo lag-com-padrao.sql
python3 consultar.py --dados ../dados --arquivo variacao-mensal.sql
python3 consultar.py --dados ../dados --arquivo checar-variacao.sql
python3 consultar.py --dados ../dados --arquivo junho-por-dia.sql
python3 consultar.py --dados ../dados --arquivo diario-do-caio.sql
python3 consultar.py --dados ../dados --arquivo minha-consulta.sql
```

O `variacao-do-caio.sql` mostra Esporte com `5` linhas, sem abril. O `variacao-mensal.sql` termina com `(30 linhas)`.

O `variacao-na-grade.sql` e o `divisao-por-zero.sql` mostram `inf` e `nan`. É de propósito: é o que o DuckDB retorna quando divide por zero.

O `minha-consulta.sql`, antes de você escrever nele, mostra `O arquivo ainda não tem consulta.` É de propósito: a consulta é sua.

O programa mostra o resultado do último comando de cada arquivo. O `checar-variacao.sql` usa isso: primeiro guarda a variação como uma view, depois faz as perguntas sobre ela. Você pode fazer o mesmo com a sua tabela diária.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
