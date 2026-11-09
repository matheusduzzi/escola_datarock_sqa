# 17. Texto, tipos e conversões

Os arquivos da aula «Texto, tipos e conversões». Rode os comandos de dentro desta pasta. Os pedidos, os pagamentos e as entregas vêm da base da Loja Exemplo, em `../dados`; o dicionário está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md). Os dois arquivos que chegaram de fora ficam em `dados/`, nesta pasta.

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `dados/extrato_pix_marco.csv` | O extrato do banco com os Pix de março: transação, data, pedido e valor, como o banco mandou. |
| `dados/fatura_rota_leve_abril.csv` | A fatura de abril da Rota Leve: data, entrega e frete. É o arquivo do exercício. |
| `tipos-do-arquivo.sql` | O tipo que o DuckDB escolhe sozinho para cada coluna do extrato. |
| `primeira-tentativa.sql` | A primeira tentativa da aula: `TRY_CAST` na chave, vírgula trocada por ponto e soma. |
| `join-direto.sql` | O pedido do extrato juntado direto com o número da loja. Termina com a mensagem de erro do DuckDB, de propósito. |
| `o-que-virou-null.sql` | As linhas em que a primeira tentativa trocou o texto por NULL. |
| `chave.sql` | O pedido antes e depois da limpeza: espaço, caixa, prefixo e zeros à esquerda. |
| `try-cast-aceita-demais.sql` | Textos que o `TRY_CAST` aceita como número sem ser uma chave. |
| `valor.sql` | Os valores com milhar e o valor vazio, nas duas conversões. |
| `data.sql` | A data do extrato com `try_strptime` e com `TRY_CAST`. |
| `relatorio-conversao.sql` | O relatório de conversão: linhas lidas, aceitas, aceitas com a chave ajustada, rejeitadas e valor aceito. |
| `rejeicoes.sql` | As linhas rejeitadas, com o texto como veio e o motivo. |
| `prova.sql` | As linhas contadas direto do arquivo e as aceitas comparadas com os Pix da loja. |
| `pix-sem-linha.sql` | Os Pix da loja que não têm linha aceita no extrato. |
| `seis-chaves.sql` | Seis pedidos do extrato no `TRY_CAST` e na regra da aula. É o pedido 1 da prática. |
| `pedido-404.sql` | A linha com letra no pedido e o Pix do pedido 404 na loja. É o pedido 2 da prática. |
| `pedido-400.sql` | O valor do pedido 400 em três conversões. É o pedido 3 da prática. |
| `ler-fatura.sql` | Lê a fatura do exercício como texto e mostra as cinco primeiras linhas. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo tipos-do-arquivo.sql
python3 consultar.py --dados ../dados --arquivo primeira-tentativa.sql
python3 consultar.py --dados ../dados --arquivo join-direto.sql
python3 consultar.py --dados ../dados --arquivo o-que-virou-null.sql
python3 consultar.py --dados ../dados --arquivo chave.sql
python3 consultar.py --dados ../dados --arquivo try-cast-aceita-demais.sql
python3 consultar.py --dados ../dados --arquivo valor.sql
python3 consultar.py --dados ../dados --arquivo data.sql
python3 consultar.py --dados ../dados --arquivo relatorio-conversao.sql
python3 consultar.py --dados ../dados --arquivo rejeicoes.sql
python3 consultar.py --dados ../dados --arquivo prova.sql
python3 consultar.py --dados ../dados --arquivo pix-sem-linha.sql
python3 consultar.py --dados ../dados --arquivo seis-chaves.sql
python3 consultar.py --dados ../dados --arquivo pedido-404.sql
python3 consultar.py --dados ../dados --arquivo pedido-400.sql
python3 consultar.py --dados ../dados --arquivo ler-fatura.sql
python3 consultar.py --dados ../dados --arquivo minhas-consultas.sql
```

O `relatorio-conversao.sql` mostra `73` linhas lidas, `67` aceitas e `6` rejeitadas. O `prova.sql` mostra `67` aceitas iguais à loja.

O `join-direto.sql` não roda: o programa mostra `A consulta não rodou` e a mensagem `Could not convert string 'PED-324' to INT64`. É o que a aula quer mostrar.

Enquanto o `minhas-consultas.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Deixe uma consulta por vez no arquivo: se houver duas, o programa mostra só o resultado da última. O `CREATE VIEW` do começo pode ficar junto da consulta. Sozinho, ele só mostra `Count` e `(0 linhas)`.

Cada consulta lê os CSVs de `dados/` pelo caminho `'dados/...'`, a partir desta pasta. Não edite os dois arquivos: a sujeira deles é o assunto da aula.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
