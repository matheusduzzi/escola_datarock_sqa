# 03. Modelagem conceitual, lógica e física

Os arquivos da aula «Modelagem conceitual, lógica e física». Rode os comandos de dentro desta pasta. Os arquivos usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `transportadora.sql` | Conta as linhas de `entregas`, os volumes e os volumes com mais de uma transportadora. |
| `tipos-do-csv.sql` | Mostra o tipo que o DuckDB deu ao preço ao ler o CSV e soma o valor dos itens com esse tipo e com `DECIMAL`. |
| `entregas-fisico.sql` | O modelo físico de pedidos e entregas: cria as tabelas com tipos e restrições, carrega a base e conta o que entrou. |
| `chave-do-caio.sql` | O mesmo arquivo com a chave sem o `tipo`. A carga para com um erro. |
| `regra-no-check.sql` | Tenta guardar "devolução só em pedido devolvido" num `CHECK`. O DuckDB recusa. |
| `fora-do-banco.sql` | As regras que olham outra linha ou outra tabela, e quantas linhas quebram cada uma. |
| `briefing-troca.md` | O pedido da Sofia para o exercício: as regras e as oito solicitações. |
| `folha-conceitual.md` | Folha 1 do exercício. Salve uma cópia com o seu nome. |
| `folha-logica.md` | Folha 2 do exercício. Salve uma cópia com o seu nome. |
| `troca-fisico.sql` | Folha 3 do exercício, com `produtos`, `pedidos` e `itens_pedido` prontos. Salve uma cópia com o seu nome. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo transportadora.sql
python3 consultar.py --dados ../dados --arquivo tipos-do-csv.sql
python3 consultar.py --dados ../dados --arquivo entregas-fisico.sql
python3 consultar.py --dados ../dados --arquivo chave-do-caio.sql
python3 consultar.py --dados ../dados --arquivo regra-no-check.sql
python3 consultar.py --dados ../dados --arquivo fora-do-banco.sql
python3 consultar.py --dados ../dados --arquivo troca-fisico.sql
```

O `entregas-fisico.sql` mostra `900` pedidos, `1074` entregas e `17910.52` de frete. O `troca-fisico.sql`, antes de você escrever nele, mostra `30` produtos, `900` pedidos e `1570` itens.

O `chave-do-caio.sql` e o `regra-no-check.sql` terminam com `A consulta não rodou. Mensagem do DuckDB:` e a mensagem. É de propósito: a aula mostra por que eles falham.

Cada arquivo começa com um banco novo, que só tem as tabelas lidas dos CSVs, cria as tabelas, carrega e roda o `SELECT` do fim. Por isso o `troca-fisico.sql` tem tudo junto: as tabelas, os `INSERT` e a consulta das regras. O resultado que aparece é o do último `SELECT`. Se uma linha do arquivo for recusada, o programa para ali e mostra a mensagem do DuckDB. Para testar uma solicitação que o banco deve recusar, acrescente o `INSERT` dela, rode, anote a mensagem e tire o `INSERT` antes de seguir.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
