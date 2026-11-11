# 32. Índices, particionamento e organização dos dados

Os arquivos da aula «Índices, particionamento e organização dos dados». Rode os comandos de dentro desta pasta. O `consultar.py` e o `plano.py` leem a base da Loja Exemplo em `../dados` (o dicionário está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md)), mas as consultas dessa aula usam o histórico que o `montar.sql` cria.

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O histórico

O `montar.sql` cria, nesta pasta, o arquivo `historico.duckdb` e a pasta `historico_por_mes/`. Leva alguns segundos e ocupa cerca de 130 MB. São 3 milhões de itens, de dezembro de 2021 a junho de 2026, gerados por uma regra fixa para ter volume: os valores não são vendas de verdade.

| Onde | O que tem |
|---|---|
| `itens_historico` (tabela no `historico.duckdb`) | os itens na ordem da carga: o id e a data crescem juntos |
| `itens_embaralhados` (tabela no `historico.duckdb`) | as mesmas linhas gravadas noutra ordem |
| `historico_por_mes/` | as mesmas linhas em arquivos Parquet, uma pasta por mês (`ano=2026/mes=5/`) |

Colunas das três: `id_item`, `id_pedido`, `id_cliente`, `data_hora_pedido`, `canal`, `categoria`, `valor`. Os arquivos por mês têm também `ano` e `mes`, que vêm do nome da pasta.

Rodar o `montar.sql` de novo recria tudo e apaga os índices que você criou. Cada índice aumenta o `historico.duckdb`, e rodar o `montar.sql` de novo não diminui o arquivo: para voltar ao tamanho do começo, apague o `historico.duckdb` e rode o `montar.sql`.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `plano.py` | O programa da aula 31, que mostra o plano. Na leitura, o detalhe traz o tipo (`Sequential Scan` ou `Index Scan`) e, nos arquivos Parquet, quantos arquivos ele abre. |
| `montar.sql` | Cria o histórico. Rode antes de tudo. |
| `seletividade.sql` | Conta quantas linhas cada filtro da aula pega. |
| `grupos.sql` | Conta em quantos grupos de linhas a resposta de cada filtro pode estar, nas duas tabelas. |
| `grupos-detalhe.sql` | Mostra a menor e a maior data dos três primeiros grupos de cada tabela. |
| `busca-por-id.sql` | A tela do atendimento: os itens de um pedido. |
| `busca-por-id-embaralhado.sql` | A mesma busca, na tabela embaralhada. |
| `indice-id-pedido.sql` | Cria o índice em `id_pedido` nas duas tabelas. |
| `relatorio-do-mes.sql` | O relatório de maio de 2026, por canal. |
| `relatorio-do-mes-embaralhado.sql` | O mesmo relatório, na tabela embaralhada. |
| `relatorio-por-arquivo.sql` | O mesmo relatório nos arquivos por mês, com o filtro em `ano` e `mes`. |
| `relatorio-por-arquivo-data.sql` | O mesmo relatório nos arquivos por mês, com o filtro pela data do pedido. É o pedido 2 da prática. |
| `vendido-eletro.sql` | O vendido da categoria Eletro. |
| `indice-categoria.sql` | Cria o índice em `categoria`. É o pedido 1 da prática. |
| `cliente.sql`, `painel-do-dia.sql`, `canal-do-ano.sql`, `presentes.sql` | As quatro consultas do exercício. |
| `escolhas.md` | A folha do exercício. Salve uma cópia com o seu nome. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo montar.sql
python3 consultar.py --dados ../dados --arquivo seletividade.sql
python3 consultar.py --dados ../dados --arquivo grupos-detalhe.sql
python3 consultar.py --dados ../dados --arquivo grupos.sql
python3 consultar.py --dados ../dados --arquivo busca-por-id.sql
python3 plano.py --dados ../dados --arquivo busca-por-id.sql --real
python3 consultar.py --dados ../dados --arquivo indice-id-pedido.sql
python3 plano.py --dados ../dados --arquivo busca-por-id.sql --real
python3 plano.py --dados ../dados --arquivo busca-por-id.sql
python3 plano.py --dados ../dados --arquivo busca-por-id-embaralhado.sql --real
python3 consultar.py --dados ../dados --arquivo relatorio-do-mes.sql
python3 consultar.py --dados ../dados --arquivo relatorio-do-mes-embaralhado.sql
python3 plano.py --dados ../dados --arquivo relatorio-do-mes.sql --real
python3 plano.py --dados ../dados --arquivo relatorio-do-mes-embaralhado.sql --real
python3 consultar.py --dados ../dados --arquivo relatorio-por-arquivo.sql
python3 plano.py --dados ../dados --arquivo relatorio-por-arquivo.sql
python3 consultar.py --dados ../dados --arquivo relatorio-por-arquivo-data.sql
python3 plano.py --dados ../dados --arquivo relatorio-por-arquivo-data.sql --real
python3 consultar.py --dados ../dados --arquivo vendido-eletro.sql
python3 consultar.py --dados ../dados --arquivo indice-categoria.sql
python3 plano.py --dados ../dados --arquivo vendido-eletro.sql --real
python3 consultar.py --dados ../dados --arquivo cliente.sql
python3 consultar.py --dados ../dados --arquivo painel-do-dia.sql
python3 consultar.py --dados ../dados --arquivo canal-do-ano.sql
python3 consultar.py --dados ../dados --arquivo presentes.sql
```

O `montar.sql` termina com três linhas, uma por forma de guardar o histórico, todas com `3000000` linhas e `1500000` pedidos. O `busca-por-id.sql` mostra os 2 itens do pedido `1400000`. O `grupos.sql` mostra `25` grupos nas duas tabelas.

Para o exercício, rode o `plano.py` com `--real` em cada consulta, antes e depois de criar os seus índices.

## Se aparecer um erro

- `Cannot open database "historico.duckdb" in read-only mode: database does not exist`: o histórico ainda não existe na pasta de onde você rodou. Entre na pasta da aula e rode o `montar.sql`.
- `No files found that match the pattern "historico_por_mes/*/*/*.parquet"`: mesma coisa, para os arquivos por mês.
- `Could not set lock on file`: outro programa está com o `historico.duckdb` aberto para escrita. Feche e rode de novo.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
