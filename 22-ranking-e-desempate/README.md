# 22. Ranking e desempate

Os arquivos da aula «Ranking e desempate». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa do diagnóstico. |
| `repetir.py` | Roda o mesmo `.sql` várias vezes, cada vez numa conexão nova, e conta quantos resultados diferentes saíram. Mostra as linhas que mudaram. |
| `vendas-fevereiro.sql` | As vendas de fevereiro por produto: unidades e pedidos. A tabela de partida da aula. |
| `vitrine-sem-desempate.sql` | Os 3 mais vendidos de cada categoria com `ROW_NUMBER`, ordenando só por unidades. |
| `vitrine-com-regra.sql` | A mesma vitrine com a regra da Lúcia: unidades, pedidos e `id_produto`. |
| `empates-na-regra.sql` | Os produtos que ainda empatam em unidades e em pedidos na mesma categoria. |
| `tres-funcoes.sql` | `ROW_NUMBER`, `RANK` e `DENSE_RANK` lado a lado, na Casa e no Eletro. |
| `desc-esquecido.sql` | A regra da Lúcia com um `DESC` a menos, comparada com a regra certa. |
| `ranking-geral.sql` | Pedido 1 da prática: `RANK` e `DENSE_RANK` da loja inteira, sem partição. |
| `quantos-entram.sql` | Pedido 2 da prática: quantos produtos passam no corte "até 3" com cada função. |
| `vitrine-sem-particao.sql` | Pedido 3 da prática: a regra da Lúcia sem o `PARTITION BY`. |
| `vendas-marco.sql` | A tabela de partida do exercício: as vendas de março por produto, com preço de lista e faturamento. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo vendas-fevereiro.sql
python3 consultar.py --dados ../dados --arquivo vitrine-sem-desempate.sql
python3 repetir.py --dados ../dados --arquivo vitrine-sem-desempate.sql
python3 consultar.py --dados ../dados --arquivo vitrine-com-regra.sql
python3 repetir.py --dados ../dados --arquivo vitrine-com-regra.sql
python3 consultar.py --dados ../dados --arquivo empates-na-regra.sql
python3 consultar.py --dados ../dados --arquivo tres-funcoes.sql
python3 consultar.py --dados ../dados --arquivo desc-esquecido.sql
python3 consultar.py --dados ../dados --arquivo ranking-geral.sql
python3 consultar.py --dados ../dados --arquivo quantos-entram.sql
python3 consultar.py --dados ../dados --arquivo vitrine-sem-particao.sql
python3 consultar.py --dados ../dados --arquivo vendas-marco.sql
python3 consultar.py --dados ../dados --arquivo minhas-consultas.sql
python3 repetir.py --dados ../dados --arquivo minhas-consultas.sql
```

O `vitrine-sem-desempate.sql` pode sair diferente cada vez que você roda. É esse o ponto da aula. O `repetir.py` nele costuma mostrar mais de 1 resultado; o número muda de rodada para rodada. Se der 1, rode de novo. No `vitrine-com-regra.sql` ele mostra `Resultados diferentes: 1.`

O `repetir.py` roda 20 vezes. Para mudar, use `--vezes`, por exemplo `--vezes 50`.

Enquanto o `minhas-consultas.sql` só tiver comentários, os dois programas avisam `O arquivo ainda não tem consulta` e não rodam nada. Deixe uma consulta por vez no arquivo: se houver duas, o programa mostra só o resultado da última.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
