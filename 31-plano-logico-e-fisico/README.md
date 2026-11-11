# 31. Plano lógico e físico

Os arquivos da aula «Plano lógico e físico». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `plano.py` | Mostra o plano que o DuckDB monta para a última consulta de um arquivo `.sql`, com a estimativa de linhas de cada operador. Com `--real`, roda a consulta e mostra também as linhas de verdade. Com `--logico`, mostra o plano lógico antes e depois do otimizador. |
| `montar.sql` | Cria o arquivo `loja.duckdb` nesta pasta, com as views da aula 30, «Organizar camadas de consulta». Rode este antes do `pedido-por-id.sql` e do `pedidos-acima-de-mil.sql`. |
| `pedido-por-id.sql` | A consulta da tela do atendimento: um pedido da `regra_pedido` pelo id. |
| `pedidos-acima-de-mil.sql` | A lista da diretoria: os pedidos da `regra_pedido` acima de R$ 1.000. |
| `vendido-por-canal.sql` | O vendido por canal, com o filtro no `WHERE`. É a consulta das seções 3 a 5. |
| `vendido-por-canal-subconsulta.sql` | A mesma pergunta, com o filtro numa subconsulta. É o pedido 1 da prática. |
| `painel-do-caio.sql` | O painel da aula 30, numa consulta só. É o pedido 2. |
| `consulta-da-lucia.sql` | A consulta do exercício: vendido de maio por categoria, clientes de SP. |
| `consulta-da-ia.sql` | A versão que a IA mandou para a mesma pergunta. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo montar.sql
python3 consultar.py --dados ../dados --arquivo pedido-por-id.sql
python3 consultar.py --dados ../dados --arquivo pedidos-acima-de-mil.sql
python3 plano.py --dados ../dados --arquivo pedido-por-id.sql --real
python3 plano.py --dados ../dados --arquivo pedidos-acima-de-mil.sql --real
python3 plano.py --dados ../dados --arquivo vendido-por-canal.sql --logico
python3 plano.py --dados ../dados --arquivo vendido-por-canal.sql
python3 plano.py --dados ../dados --arquivo vendido-por-canal.sql --real
python3 plano.py --dados ../dados --arquivo vendido-por-canal-subconsulta.sql
python3 plano.py --dados ../dados --arquivo painel-do-caio.sql --real
python3 consultar.py --dados ../dados --arquivo consulta-da-lucia.sql
python3 consultar.py --dados ../dados --arquivo consulta-da-ia.sql
python3 plano.py --dados ../dados --arquivo consulta-da-lucia.sql
python3 plano.py --dados ../dados --arquivo consulta-da-ia.sql
python3 plano.py --dados ../dados --arquivo consulta-da-lucia.sql --real
```

O `montar.sql` mostra as seis views com `900`, `1570`, `1040`, `900`, `6` e `2` linhas. O `pedido-por-id.sql` mostra o pedido `680` com valor `228.90`. O `plano.py --real` do `pedido-por-id.sql` termina em `(17 operadores)`.

## Como ler a saída do plano.py

Cada linha é um operador. O recuo mostra quem alimenta quem: um operador recebe as linhas dos operadores logo abaixo dele, com um recuo a mais. Leia de baixo para cima: as leituras dos arquivos ficam no fundo, e o resultado sai pelo operador do topo.

- `estimado`, com `~`, é o palpite do DuckDB antes de rodar.
- `real` só aparece com `--real`, e é a quantidade de linhas que o operador entregou.
- `detalhe` traz a condição do filtro ou da junção, os grupos e as somas, e as colunas que cada leitura tira do arquivo.

O tempo de cada operador fica de fora de propósito: ele muda de uma execução para outra. As linhas são sempre as mesmas.

O `--real` roda a consulta de verdade. Use só com `SELECT`: num `INSERT`, a linha é gravada.

Se aparecer `Cannot open database "loja.duckdb" in read-only mode: database does not exist`, o arquivo das views ainda não existe na pasta de onde você rodou. Entre na pasta da aula e rode o `montar.sql`.

Para o pedido 3 da prática, salve uma cópia do `pedido-por-id.sql` como `pedido-9999.sql` e troque `680` por `9999` antes de rodar.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
