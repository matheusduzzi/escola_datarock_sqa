# 13. Operações de conjuntos

Os arquivos da aula «Operações de conjuntos». Rode os comandos de dentro desta pasta. As listas da aula e do exercício estão em `dados/`, nesta pasta, e o `consultar.py` lê essa pasta sem precisar de `--dados`. Cada CSV vira uma tabela com o nome do arquivo.

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado do último comando. É o mesmo programa das outras aulas. |
| `dados/romaneio.csv` | A lista do fornecedor: uma linha por caixa que ele diz que mandou (`linha`, `produto`). |
| `dados/doca1.csv`, `dados/doca2.csv` | O que o leitor de cada doca bipou: uma linha por caixa (`hora`, `produto`). |
| `dados/inscricoes_app.csv`, `dados/inscricoes_loja.csv` | As inscrições do sorteio do exercício: uma linha por inscrição (`data_inscricao`, `id_cliente`). |
| `dados/funcionarios.csv` | Os clientes que trabalham na loja (`id_cliente`, `setor`). É do exercício. |
| `listas.sql` | Quantas caixas de cada produto há no romaneio e em cada doca. |
| `consulta-do-caio.sql` | A primeira resposta para a Helena, com `UNION` e `EXCEPT`. |
| `empilhar.sql` | As duas docas com `UNION ALL`. |
| `empilhar-sem-repetir.sql` | As duas docas com `UNION`. |
| `faltou-produtos.sql` | Romaneio `EXCEPT` bipadas. |
| `faltou-caixas.sql` | Romaneio `EXCEPT ALL` bipadas. |
| `veio-a-mais.sql` | Bipadas `EXCEPT ALL` romaneio. |
| `bateu-produtos.sql` | Romaneio `INTERSECT` bipadas. |
| `bateu-caixas.sql` | Romaneio `INTERSECT ALL` bipadas. |
| `conta-por-produto.sql` | A conta por produto sem `EXCEPT` nem `INTERSECT`: m, n e o que cada operação deve dar. |
| `reconciliar.sql` | As duas somas que fecham: romaneio = bateu + faltou; bipadas = bateu + veio a mais. |
| `linha-inteira.sql` | `UNION` com `SELECT *`: a hora entra na comparação. |
| `colunas-trocadas.sql` | `EXCEPT ALL` com `SELECT *` dos dois lados. Não roda, de propósito. |
| `vazio.sql` | O que `UNION`, `EXCEPT ALL`, `INTERSECT` e o `JOIN` fazem com o valor vazio. |
| `ordem.sql` | Qual operação roda primeiro quando há mais de uma. |
| `recebimento.sql` | A lista da reclamação: por produto, quantas caixas faltaram e quantas vieram a mais. |
| `doca2-menos-doca1.sql` | Prática, pedido 1. |
| `romaneio-e-doca1.sql` | Prática, pedido 2. |
| `sem-parenteses.sql` | Prática, pedido 3. |
| `previsoes.sql` | Exercício, tarefa 1: as sete consultas do sorteio. Rode só depois de preencher a folha. |
| `folha-previsao.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `sorteio.sql` | O arquivo das tarefas 2 e 3, só com comentários. A consulta é você que escreve. |

## Comandos

```bash
python3 consultar.py --arquivo listas.sql
python3 consultar.py --arquivo consulta-do-caio.sql
python3 consultar.py --arquivo empilhar.sql
python3 consultar.py --arquivo empilhar-sem-repetir.sql
python3 consultar.py --arquivo faltou-produtos.sql
python3 consultar.py --arquivo faltou-caixas.sql
python3 consultar.py --arquivo veio-a-mais.sql
python3 consultar.py --arquivo bateu-produtos.sql
python3 consultar.py --arquivo bateu-caixas.sql
python3 consultar.py --arquivo conta-por-produto.sql
python3 consultar.py --arquivo reconciliar.sql
python3 consultar.py --arquivo linha-inteira.sql
python3 consultar.py --arquivo colunas-trocadas.sql
python3 consultar.py --arquivo vazio.sql
python3 consultar.py --arquivo ordem.sql
python3 consultar.py --arquivo recebimento.sql
python3 consultar.py --arquivo doca2-menos-doca1.sql
python3 consultar.py --arquivo romaneio-e-doca1.sql
python3 consultar.py --arquivo sem-parenteses.sql
python3 consultar.py --arquivo previsoes.sql
python3 consultar.py --arquivo sorteio.sql
```

O `listas.sql` mostra 12 caixas no romaneio, 5 na doca 1 e 4 na doca 2. O `consulta-do-caio.sql` mostra `5` e `Cortina`. O `faltou-caixas.sql` sai com 4 linhas e o `reconciliar.sql` com `12  9  8  4  1  True  True`. O `recebimento.sql` sai com 4 linhas.

O `colunas-trocadas.sql` não roda, de propósito: o programa mostra "A consulta não rodou" e a mensagem do DuckDB sobre a coluna `linha`. A aula explica por quê.

O `sorteio.sql` começa só com comentários. Enquanto você não escrever a consulta, o programa avisa que o arquivo ainda não tem consulta e não roda nada.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
