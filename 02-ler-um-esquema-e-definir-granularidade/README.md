# 02. Ler um esquema e definir granularidade

Os arquivos da aula «Ler um esquema e definir granularidade». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa do diagnóstico. |
| `chaves.sql` | Compara o número de linhas com o de combinações diferentes de cada candidata a chave. |
| `repetidas.sql` | Mostra as combinações de pedido, volume e tentativa que repetem em `entregas`. |
| `cardinalidade.sql` | Mínimo, máximo e pais sem filho de quatro ligações: pedido para itens, entregas e volumes, e volume para tentativas. |
| `sem-entrega.sql` | Os pedidos sem nenhuma entrega, por status. |
| `orfaos.sql` | Itens e entregas que apontam para um pedido ou produto que não existe. |
| `um-pedido.sql` | Um pedido com itens e entregas juntados direto. Vem com o pedido 47; troque o número para ver outro. |
| `multiplicacao.sql` | A consulta do Caio na base toda, ao lado das somas de cada tabela. |
| `por-pedido.sql` | Uma linha por pedido, com itens e frete somados antes de juntar. |
| `mapa.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `consulta-do-caio.sql` | A consulta do exercício, para você rodar antes de corrigir. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo chaves.sql
python3 consultar.py --dados ../dados --arquivo repetidas.sql
python3 consultar.py --dados ../dados --arquivo cardinalidade.sql
python3 consultar.py --dados ../dados --arquivo sem-entrega.sql
python3 consultar.py --dados ../dados --arquivo orfaos.sql
python3 consultar.py --dados ../dados --arquivo um-pedido.sql
python3 consultar.py --dados ../dados --arquivo multiplicacao.sql
python3 consultar.py --dados ../dados --arquivo por-pedido.sql
python3 consultar.py --dados ../dados --arquivo consulta-do-caio.sql
python3 consultar.py --dados ../dados --arquivo minhas-consultas.sql
```

O `chaves.sql` termina com a linha de `entregas` em que a chave tem quatro colunas: `1074` linhas e `1074` diferentes. O `por-pedido.sql` mostra `900` linhas, `223480.76` de itens e `17910.52` de frete.

Enquanto o `minhas-consultas.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Deixe uma consulta por vez no arquivo: se houver duas, o programa mostra só o resultado da última.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
