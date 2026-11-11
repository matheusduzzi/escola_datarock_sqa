# 30. Organizar camadas de consulta

Os arquivos da aula «Organizar camadas de consulta». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `painel-do-caio.sql` | O painel da Lúcia como o Caio fez: vendido e recebido por mês numa consulta só. |
| `um-pedido.sql` | As linhas que o `JOIN` do Caio monta para o pedido 680, antes do `GROUP BY`. |
| `montar.sql` | Cria o arquivo `loja.duckdb` nesta pasta, com as views de preparação, regra e consumo. Cada view tem o contrato de saída escrito em cima. Rode este primeiro. |
| `painel.sql` | O painel da Lúcia lido da camada de consumo. |
| `cobranca.sql` | A lista de cobrança do financeiro, lida da camada de consumo. |
| `checar-contratos.sql` | Uma pergunta com resposta conhecida para cada contrato. |
| `ticket-por-canal.sql` | Um relatório novo, o ticket médio por canal, como mais uma view de consumo. É o pedido 1 da prática. |
| `regra-do-caio.sql` | A regra com um `JOIN` só, que o Caio sugeriu, passando pelas checagens da regra. É o pedido 2. |
| `frete-do-caio.sql` | A consulta do exercício, para você rodar antes de separar em camadas. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-camadas.sql` | Um arquivo para as três views do exercício. |
| `minhas-checagens.sql` | Um arquivo para as checagens do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo painel-do-caio.sql
python3 consultar.py --dados ../dados --arquivo um-pedido.sql
python3 consultar.py --dados ../dados --arquivo montar.sql
python3 consultar.py --dados ../dados --arquivo painel.sql
python3 consultar.py --dados ../dados --arquivo cobranca.sql
python3 consultar.py --dados ../dados --arquivo checar-contratos.sql
python3 consultar.py --dados ../dados --arquivo ticket-por-canal.sql
python3 consultar.py --dados ../dados --arquivo regra-do-caio.sql
python3 consultar.py --dados ../dados --arquivo frete-do-caio.sql
python3 consultar.py --dados ../dados --arquivo minhas-camadas.sql
python3 consultar.py --dados ../dados --arquivo minhas-checagens.sql
```

O `montar.sql` mostra as seis views com as linhas de cada uma: `900`, `1570`, `1040`, `900`, `6` e `2`. O `checar-contratos.sql` tem `12` linhas, todas com `ok`. O `painel.sql` mostra `30329.65` no vendido de maio.

Se aparecer `Cannot open database "loja.duckdb" in read-only mode: database does not exist`, o arquivo das camadas ainda não existe na pasta de onde você rodou. Entre na pasta da aula e rode o `montar.sql`.

Rodar o `montar.sql` de novo recria as views da aula do mesmo jeito. As suas views do exercício ficam no mesmo arquivo e não são apagadas por ele. Se quiser começar do zero, apague o `loja.duckdb` e rode o `montar.sql`.

Enquanto o `minhas-camadas.sql` ou o `minhas-checagens.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Um arquivo pode ter várias instruções, como o `montar.sql`: o programa roda todas e mostra o resultado da última.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
