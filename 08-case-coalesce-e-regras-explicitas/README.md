# 08. CASE, COALESCE e regras explícitas

Os arquivos da aula «CASE, COALESCE e regras explícitas». Rode os comandos de dentro desta pasta. Os pedidos, os itens e as entregas vêm da base da Loja Exemplo, em `../dados`; o dicionário está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado do último comando. É o mesmo programa das outras aulas. |
| `faixas-caio.sql` | A primeira versão das faixas da campanha, com o `ELSE` virando faixa e sem `COALESCE` no desconto. |
| `cupom.sql` | Conta os itens com desconto vazio, zero e de verdade, e mostra o `CASE desconto WHEN NULL` e o `COALESCE` antes de classificar. |
| `valor-do-pedido.sql` | Calcula o valor de cada pedido com e sem `COALESCE` no desconto. |
| `faixas.sql` | A regra da tabela de decisão do Renato e a contagem de pedidos por faixa. |
| `casos-fronteira.sql` | A mesma regra, com os oito casos da tabela de decisão escritos com `VALUES`. |
| `tabela-decisao.md` | A folha: o modelo 1 da aula preenchido e o modelo 2 do exercício em branco. Salve uma cópia com o seu nome. |
| `situacao-entrega.sql` | O arquivo do exercício, só com comentários. A consulta é você que escreve. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo faixas-caio.sql
python3 consultar.py --dados ../dados --arquivo cupom.sql
python3 consultar.py --dados ../dados --arquivo valor-do-pedido.sql
python3 consultar.py --dados ../dados --arquivo faixas.sql
python3 consultar.py --dados ../dados --arquivo casos-fronteira.sql
python3 consultar.py --dados ../dados --arquivo situacao-entrega.sql
```

O `faixas-caio.sql` mostra `828` pedidos em `até 199`, com `608` de valor vazio. O `cupom.sql` mostra `1239` vazios, `141` zeros e `190` descontos. O `valor-do-pedido.sql` mostra `608` pedidos vazios sem o `COALESCE`. O `faixas.sql` mostra `411`, `191`, `177` e `121`. No `casos-fronteira.sql`, os oito casos saem com `True` em `bate`.

O `situacao-entrega.sql` começa só com comentários. Enquanto você não escrever a consulta, o programa avisa que o arquivo ainda não tem consulta e não roda nada.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
