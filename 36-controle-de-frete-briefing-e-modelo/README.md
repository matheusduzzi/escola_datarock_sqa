# 36. Controle de frete: briefing e modelo

Os arquivos da aula «Controle de frete: briefing e modelo». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa do diagnóstico. |
| `quatro-respostas.sql` | Quatro jeitos de calcular o frete de um pedido em maio. |
| `cenarios-fixos.sql` | As linhas de `entregas` dos cinco pedidos dos cenários, com a parte do frete de cada linha. É a base dos pedidos 1 e 2 da prática. |
| `partes-de-maio.sql` | O frete de maio separado em entrega, tentativa que falhou e devolução. |
| `competencia-dois-meses.sql` | O frete pelo mês do pedido e pelo mês da tentativa, de abril em diante. |
| `maio-e-junho.sql` | O custo por pedido e por volume de maio e de junho, com as linhas sem fatura e os volumes na rua. |
| `rateio-tres-regras.sql` | O frete de maio dividido por categoria pelo valor, pela quantidade e por item, com a soma que fecha. |
| `rateio-de-um-pedido.sql` | O rateio do pedido 687 item por item e o centavo do arredondamento. |
| `frete-no-join.sql` | O frete de maio somado depois de juntar entregas com itens. É o pedido 3 da prática. |
| `premissas-do-modelo.sql` | O que o modelo supõe sobre os dados e quantos casos contrariam cada premissa. |
| `contrato-do-frete.md` | O contrato de métricas da Marta, com o modelo de análise, os cenários fixos e as verificações. A aula 37 parte dele. |
| `modelo-de-contrato.md` | Os campos de um contrato, em branco. Use no exercício. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo quatro-respostas.sql
python3 consultar.py --dados ../dados --arquivo cenarios-fixos.sql
python3 consultar.py --dados ../dados --arquivo partes-de-maio.sql
python3 consultar.py --dados ../dados --arquivo competencia-dois-meses.sql
python3 consultar.py --dados ../dados --arquivo maio-e-junho.sql
python3 consultar.py --dados ../dados --arquivo rateio-tres-regras.sql
python3 consultar.py --dados ../dados --arquivo rateio-de-um-pedido.sql
python3 consultar.py --dados ../dados --arquivo frete-no-join.sql
python3 consultar.py --dados ../dados --arquivo premissas-do-modelo.sql
python3 consultar.py --dados ../dados --arquivo minhas-consultas.sql
```

O `quatro-respostas.sql` mostra quatro linhas, de `20.06` a `22.42` na coluna `por_pedido`. O `premissas-do-modelo.sql` mostra 7 premissas, todas com `0`.

Enquanto o `minhas-consultas.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Deixe uma consulta por vez no arquivo: se houver duas, o programa mostra só o resultado da última.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
