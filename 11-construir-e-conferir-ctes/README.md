# 11. Construir e conferir CTEs

Os arquivos da aula «Construir e conferir CTEs». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `relatorio-ia.sql` | O relatório da IA para o Renato: venda e pedidos por categoria e mês. Roda, e o total sai errado. |
| `conferencia-ia.sql` | As mesmas etapas do relatório da IA, com a tabela de conferência no fim. |
| `um-pedido.sql` | O pedido 6 dentro da etapa de itens do relatório da IA. |
| `relatorio.sql` | O relatório corrigido. |
| `conferencia.sql` | As etapas corrigidas, com a tabela de conferência no fim. |
| `o-que-saiu.sql` | A base inteira por status: o que entra na etapa `vendas` e o que sai. |
| `conferencia-do-caio.sql` | A correção do Caio, sem o `COALESCE`. É o pedido 1 da prática. |
| `frete-ia.sql` | O relatório de frete da IA para o Rafael. É o arquivo do exercício. |
| `folha-conferencia.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minha-conferencia.sql` | O arquivo da conferência do `frete-ia.sql`, tarefa 1 do exercício. |
| `meu-frete.sql` | O arquivo do relatório de frete corrigido, tarefa 3 do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo relatorio-ia.sql
python3 consultar.py --dados ../dados --arquivo conferencia-ia.sql
python3 consultar.py --dados ../dados --arquivo um-pedido.sql
python3 consultar.py --dados ../dados --arquivo relatorio.sql
python3 consultar.py --dados ../dados --arquivo conferencia.sql
python3 consultar.py --dados ../dados --arquivo o-que-saiu.sql
python3 consultar.py --dados ../dados --arquivo conferencia-do-caio.sql
python3 consultar.py --dados ../dados --arquivo frete-ia.sql
python3 consultar.py --dados ../dados --arquivo minha-conferencia.sql
python3 consultar.py --dados ../dados --arquivo meu-frete.sql
```

O `relatorio-ia.sql` e o `relatorio.sql` têm 29 linhas cada: seis meses e cinco categorias, menos Esporte em abril, que não vendeu.

O `conferencia.sql` mostra o mesmo total nas três etapas: `190536.3`, com diferença `0.0`. O `conferencia-ia.sql` mostra `425052.33` a partir da segunda etapa.

O `minha-conferencia.sql` e o `meu-frete.sql`, antes de você escrever neles, mostram `O arquivo ainda não tem consulta.` A consulta é sua.

Para olhar uma etapa sozinha, troque só o `SELECT` do fim do arquivo, por exemplo por `SELECT * FROM itens_venda WHERE id_pedido = 6`. Não edite os CSVs de `../dados`.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
