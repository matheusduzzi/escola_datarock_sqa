# 07. Warehouse, lake e responsabilidade da camada

Os arquivos da aula «Warehouse, lake e responsabilidade da camada». Rode os comandos de dentro desta pasta. Os pedidos, os itens e os produtos vêm da base da Loja Exemplo, em `../dados`; o dicionário está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `bruto.sql` | Lê o arquivo de itens como chegou, tudo texto, e compara o maior e o menor preço como texto e como número. |
| `camadas.sql` | Monta as camadas bruto, tratado e consumo como views e conta as linhas de item em cada uma, com janeiro no consumo. |
| `dois-paineis.sql` | Monta as mesmas camadas e calcula janeiro pelo painel que lê o consumo e pelo painel que escreve a própria conta. |
| `mapa-camadas.md` | A folha do exercício: o mapa do painel do Renato preenchido e o do frete em branco. Salve uma cópia com o seu nome. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo bruto.sql
python3 consultar.py --dados ../dados --arquivo camadas.sql
python3 consultar.py --dados ../dados --arquivo dois-paineis.sql
```

O `bruto.sql` mostra `1570` linhas, o maior preço como texto `99.90` e como número `349.00`. O `camadas.sql` mostra `1570` nas três camadas e `32815.10` em `janeiro_vendido`. O `dois-paineis.sql` mostra `32815.10` e `37261.70`.

Os três arquivos leem os CSVs pelo caminho `../dados/`, a partir desta pasta. Se rodar de outra pasta, o DuckDB avisa que não achou o arquivo.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
