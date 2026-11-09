# 15. Juntar múltiplos fatos

Os arquivos da aula «Juntar múltiplos fatos». Rode os comandos de dentro desta pasta. Os dados são os da base da Loja Exemplo, em `../dados`: pedidos, itens, pagamentos e entregas. O dicionário está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `direto.sql` | A consulta que chegou pronta: junta pedidos, itens, pagamentos e entregas de uma vez e soma. |
| `um-pedido.sql` | O pedido 548 juntado direto, uma linha para cada item, pagamento e volume. |
| `quem-fecha.sql` | Nos pedidos entregues, quem multiplica na junção direta e quem tem tantos itens quanto pagamentos. |
| `leque.sql` | Quantas linhas cada pedido vira na junção, antes de juntar. |
| `por-pedido.sql` | Cada tabela somada por pedido antes do JOIN, com a linha que faz as mesmas somas em cada tabela sozinha. |
| `sem-agregar.sql` | Um JOIN que não multiplica: itens com pedidos e produtos, por categoria. |
| `soma-distinta.sql` | O remendo do `SUM(DISTINCT)` comparado com o recebido certo. |
| `reconciliar.sql` | A reconciliação de pedidos, pagamentos e entregas, por status. |
| `fechamento.sql` | O arquivo do exercício. Salve uma cópia com o seu nome. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo direto.sql
python3 consultar.py --dados ../dados --arquivo um-pedido.sql
python3 consultar.py --dados ../dados --arquivo quem-fecha.sql
python3 consultar.py --dados ../dados --arquivo leque.sql
python3 consultar.py --dados ../dados --arquivo por-pedido.sql
python3 consultar.py --dados ../dados --arquivo sem-agregar.sql
python3 consultar.py --dados ../dados --arquivo soma-distinta.sql
python3 consultar.py --dados ../dados --arquivo reconciliar.sql
python3 consultar.py --dados ../dados --arquivo fechamento.sql
```

O `direto.sql` mostra `2534` linhas juntadas e `366` pedidos entregues que não fecham. O `por-pedido.sql` mostra as duas linhas iguais: `900` pedidos, `223480.76` de itens, `190007.7` recebido e `17910.52` de frete. O `reconciliar.sql` mostra os `747` pedidos entregues na linha `fecha`.

O `fechamento.sql`, antes de você escrever nele, mostra `O arquivo ainda não tem consulta.` É de propósito: a consulta é sua.

Para a prática guiada, faça uma cópia do arquivo antes de mudar: troque o `548` do `um-pedido.sql` pelo pedido que a aula pede, e o `SELECT` final do `reconciliar.sql` pela lista. Não edite os CSVs da pasta `../dados`.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
