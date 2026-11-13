# 10. Subqueries e CTEs

Os arquivos da aula «Subqueries e CTEs». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `consulta-do-caio.sql` | A primeira resposta do Caio: quem fez mais de um pedido em março. |
| `etapas-aninhadas.sql` | A recompra em até 30 dias dos clientes de março, com uma subquery dentro da outra. |
| `etapas-cte.sql` | A mesma recompra, em etapas com nome: `compras`, `compra_marco` e `proxima`. |
| `cada-etapa.sql` | As mesmas etapas, e quantas linhas cada uma tem. |
| `proxima-sem-min.sql` | A etapa `proxima` sem o `MIN`. Ela dá erro de propósito. |
| `canal-do-caio.sql` | A recompra por canal, do jeito que o Caio escreveu. É o pedido 3 da prática. |
| `folha-plano.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `cupom-etapas.sql` | O arquivo da sua consulta em etapas, com CTEs. |
| `cupom-aninhado.sql` | O arquivo da mesma consulta com subqueries, sem `WITH`. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo consulta-do-caio.sql
python3 consultar.py --dados ../dados --arquivo etapas-aninhadas.sql
python3 consultar.py --dados ../dados --arquivo etapas-cte.sql
python3 consultar.py --dados ../dados --arquivo cada-etapa.sql
python3 consultar.py --dados ../dados --arquivo proxima-sem-min.sql
python3 consultar.py --dados ../dados --arquivo canal-do-caio.sql
python3 consultar.py --dados ../dados --arquivo cupom-etapas.sql
python3 consultar.py --dados ../dados --arquivo cupom-aninhado.sql
```

O `etapas-aninhadas.sql` e o `etapas-cte.sql` mostram a mesma linha: `74` clientes de março, `54` que voltaram em até 30 dias, `73.0` por cento.

O `proxima-sem-min.sql` termina com `A consulta não rodou.` e a mensagem do DuckDB `More than one row returned by a subquery used as an expression`. É de propósito: a aula mostra por que o `MIN` faz falta.

O `cupom-etapas.sql` e o `cupom-aninhado.sql`, antes de você escrever neles, mostram `O arquivo ainda não tem consulta.` A consulta é sua.

Para olhar uma etapa sozinha, troque só o `SELECT` do fim do arquivo, por exemplo por `SELECT * FROM compra_marco ORDER BY dia_marco`. Não edite os CSVs de `../dados`.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
