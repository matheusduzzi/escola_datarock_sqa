# 01. Onde a consulta roda

Os arquivos da aula «Onde a consulta roda». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`.

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa do diagnóstico. |
| `dialetos.sql` | A parte de pedidos cancelados com `/`, `//` e `100.0`. |
| `por-mes.sql` | Pedidos por mês com `date_trunc`. |
| `colunas.sql` | Grava `entregas.parquet` nesta pasta e mostra quantos bytes cada coluna ocupa no arquivo. |
| `plano.sql` | Mostra quais colunas do `entregas.parquet` o DuckDB lê para somar o frete por mês. Rode depois do `colunas.sql`. |
| `escolhas.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `consulta-1.sql`, `consulta-2.sql` | As duas consultas da parte 2 da folha, para você ver o resultado no DuckDB antes de reescrever. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo dialetos.sql
python3 consultar.py --dados ../dados --arquivo por-mes.sql
python3 consultar.py --dados ../dados --arquivo colunas.sql
python3 consultar.py --arquivo plano.sql
python3 consultar.py --dados ../dados --arquivo consulta-1.sql
python3 consultar.py --dados ../dados --arquivo consulta-2.sql
```

O `dialetos.sql` termina com `900`, `71`, `7.888888888888889`, `7` e `7.9`. O `colunas.sql` lista dez colunas, de `id_entrega` com 4711 bytes até `tipo` com 192.

O `plano.sql` não usa `--dados`: ele lê o `entregas.parquet` que o `colunas.sql` gravou aqui. Se aparecer `No files found that match the pattern "entregas.parquet"`, rode o `colunas.sql` antes. O `entregas.parquet` pode ser apagado depois: ele sai igual toda vez.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
