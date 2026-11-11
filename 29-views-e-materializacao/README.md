# 29. Views e materialização

Os arquivos da aula «Views e materialização». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `tres-copias.sql` | As três cópias da consulta do valor por pedido, uma por relatório, com o vendido em maio de cada uma. É o pedido 1 da prática. |
| `valor-pedido.sql` | A mesma consulta como a view `valor_pedido`, lida pelos três relatórios. |
| `montar.sql` | Cria o arquivo `loja.duckdb` nesta pasta, com uma cópia de pedidos e itens, a view `valor_pedido` e a tabela `fechamento_maio`. É o pedido 2. |
| `devolucao.sql` | Muda o status do pedido 733 para devolvido e compara a view com a tabela. Rode depois do `montar.sql`. |
| `refazer-foto.sql` | Recria a tabela `fechamento_maio` depois da devolução. É o pedido 3. |
| `sem-materialized.sql` | O comando de view materializada do PostgreSQL rodado no DuckDB. Ele não roda, de propósito. |
| `briefing-transportadoras.md` | O pedido da Marta para o exercício: como os dados chegam e as três consultas. |
| `folha-decisao.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo tres-copias.sql
python3 consultar.py --dados ../dados --arquivo valor-pedido.sql
python3 consultar.py --dados ../dados --arquivo montar.sql
python3 consultar.py --dados ../dados --arquivo devolucao.sql
python3 consultar.py --dados ../dados --arquivo refazer-foto.sql
python3 consultar.py --dados ../dados --arquivo sem-materialized.sql
python3 consultar.py --dados ../dados --arquivo minhas-consultas.sql
```

Rode na ordem. O `montar.sql` volta o `loja.duckdb` ao começo, então para ver a devolução de novo rode `montar.sql` e depois `devolucao.sql`. Se você rodar o `devolucao.sql` antes do `montar.sql`, aparece `A consulta não rodou`, porque a tabela `loja.pedidos` ainda não existe.

O `tres-copias.sql` mostra `7046.47`, `30329.65` e `30769.25`. Depois do `devolucao.sql`, a view mostra `129` pedidos e a tabela continua com `130`.

O `sem-materialized.sql` mostra `syntax error at or near "MATERIALIZED"`. É de propósito: o DuckDB não tem esse comando.

O `minhas-consultas.sql`, antes de você escrever nele, mostra `O arquivo ainda não tem consulta.` É de propósito: as consultas são suas.

O programa mostra o resultado do último comando de cada arquivo. O arquivo `loja.duckdb` pode ser apagado quando você terminar.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
