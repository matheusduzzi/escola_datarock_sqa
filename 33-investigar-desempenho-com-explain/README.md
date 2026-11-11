# 33. Investigar desempenho com EXPLAIN

Os arquivos da aula «Investigar desempenho com EXPLAIN». Rode os comandos de dentro desta pasta. O `consultar.py`, o `plano.py` e o `medir.py` leem a base da Loja Exemplo em `../dados` (o dicionário está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md)), mas as consultas dessa aula usam o histórico que o `montar.py` cria.

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O histórico

O `montar.py` cria, nesta pasta, o arquivo `historico.duckdb` e a pasta `historico_por_mes/`. É o histórico da aula 32, com o tamanho que você escolher em `--milhoes`, de 1 a 30 milhões de itens. O período é sempre de dezembro de 2021 a junho de 2026: mais itens quer dizer mais pedidos no mesmo período. Os valores saem de uma regra fixa e não são vendas de verdade.

| `--milhoes` | `historico.duckdb` | `historico_por_mes/` | Tempo para montar |
|---|---|---|---|
| 1 | cerca de 25 MB | cerca de 14 MB | alguns segundos |
| 3 (padrão) | cerca de 75 MB | cerca de 42 MB | alguns segundos |
| 9 | cerca de 225 MB | cerca de 126 MB | menos de um minuto |

Os índices aumentam o `historico.duckdb`: com os dois índices em `id_pedido`, ele fica umas três vezes maior. Rodar o `montar.py` de novo apaga o arquivo e a pasta e monta tudo do zero, sem índice.

| Onde | O que tem |
|---|---|
| `itens_historico` (tabela no `historico.duckdb`) | os itens na ordem da carga: o id e a data crescem juntos |
| `itens_embaralhados` (tabela no `historico.duckdb`) | as mesmas linhas gravadas noutra ordem |
| `historico_por_mes/` | as mesmas linhas em arquivos Parquet, uma pasta por mês (`ano=2026/mes=5/`) |

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `plano.py` | O programa da aula 32, que mostra o plano. Com `--real`, a consulta roda e aparecem as linhas reais de cada operador. |
| `montar.py` | Cria o histórico com o volume de `--milhoes`. Rode antes de tudo. |
| `medir.py` | Mede o tempo da última consulta de um arquivo `.sql` e mostra a configuração, o volume e a impressão digital do resultado. Com `--perfil`, mostra também o tempo de cada operador. |
| `busca-por-id.sql` | A tela do atendimento: os itens do pedido 400000, na tabela da carga. |
| `busca-por-id-embaralhado.sql` | A mesma busca, na tabela embaralhada. |
| `indice-id-pedido.sql` | Cria o índice em `id_pedido` nas duas tabelas. |
| `apagar-indice-id-pedido.sql` | Apaga esses dois índices. |
| `relatorio-do-mes.sql` | O relatório de maio de 2026 por canal, na tabela da carga. |
| `relatorio-do-mes-embaralhado.sql` | O mesmo relatório, na tabela embaralhada. |
| `relatorio-por-arquivo.sql` | O mesmo relatório nos arquivos por mês, com o filtro em `ano` e `mes`. É o do exercício. |
| `roteiro-de-medicao.md` | Os passos de uma medição. |
| `relatorio.md` | A folha do exercício. Salve uma cópia com o seu nome. |

## Comandos

Na ordem da aula:

```bash
python3 montar.py --milhoes 3
python3 medir.py --dados ../dados --arquivo busca-por-id-embaralhado.sql
python3 plano.py --dados ../dados --arquivo busca-por-id-embaralhado.sql --real
python3 consultar.py --dados ../dados --arquivo indice-id-pedido.sql
python3 plano.py --dados ../dados --arquivo busca-por-id-embaralhado.sql --real
python3 medir.py --dados ../dados --arquivo busca-por-id-embaralhado.sql
python3 consultar.py --dados ../dados --arquivo apagar-indice-id-pedido.sql
python3 medir.py --dados ../dados --arquivo relatorio-do-mes.sql
python3 medir.py --dados ../dados --arquivo relatorio-do-mes-embaralhado.sql
python3 plano.py --dados ../dados --arquivo relatorio-do-mes.sql --real
python3 plano.py --dados ../dados --arquivo relatorio-do-mes-embaralhado.sql --real
python3 medir.py --dados ../dados --arquivo relatorio-do-mes-embaralhado.sql --perfil
```

A prática guiada:

```bash
python3 medir.py --dados ../dados --arquivo relatorio-do-mes.sql --threads 1
python3 medir.py --dados ../dados --arquivo relatorio-do-mes-embaralhado.sql --threads 1
python3 medir.py --dados ../dados --arquivo relatorio-do-mes-embaralhado.sql --threads 1 --perfil
python3 consultar.py --dados ../dados --arquivo indice-id-pedido.sql
python3 plano.py --dados ../dados --arquivo busca-por-id.sql --real
python3 medir.py --dados ../dados --arquivo busca-por-id.sql
python3 consultar.py --dados ../dados --arquivo apagar-indice-id-pedido.sql
python3 medir.py --dados ../dados --arquivo busca-por-id.sql
```

Para a tabela da seção 7, rode o `montar.py` com `--milhoes 1` e com `--milhoes 9` e meça de novo as buscas e os relatórios.

O `montar.py --milhoes 3` termina com três linhas, uma por forma de guardar o histórico, todas com `3000000` linhas e `1500000` pedidos. O `medir.py` da busca mostra `2 linhas` no resultado, e a mesma impressão digital na tabela da carga e na embaralhada. Os tempos vão ser outros na sua máquina.

## O que o medir.py aceita

| Opção | O que faz | Padrão |
|---|---|---|
| `--rodadas` | quantas conexões novas, uma por rodada | 3 |
| `--aquecimento` | execuções sem contar no começo de cada rodada | 2 |
| `--vezes` | execuções medidas em cada rodada | 10 |
| `--threads` | threads do DuckDB | 4 |
| `--perfil` | mostra também o tempo de cada operador | desligado |

## Se aparecer um erro

- `Cannot open database "historico.duckdb" in read-only mode: database does not exist`: o histórico ainda não existe na pasta de onde você rodou. Entre na pasta da aula e rode o `montar.py`.
- `No files found that match the pattern "historico_por_mes/*/*/*.parquet"`: mesma coisa, para os arquivos por mês.
- `Could not set lock on file`: outro programa está com o `historico.duckdb` aberto para escrita. Feche e rode de novo.
- `Escolha --milhoes entre 1 e 30`: o volume pedido está fora da faixa do `montar.py`.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
