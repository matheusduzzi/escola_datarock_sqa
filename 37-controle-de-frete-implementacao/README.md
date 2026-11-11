# 37. Controle de frete: implementação

Os arquivos da aula «Controle de frete: implementação». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `projeto.py` | Roda vários arquivos `.sql` em ordem, na mesma conexão, e mostra o resultado do último. Quando o último é um arquivo de testes, sai com código 1 se algum teste falhar. |
| `consultar.py` | O mesmo programa das outras aulas, para uma consulta solta. |
| `contrato-do-frete.md` | O contrato de métricas da aula 36, que essa aula implementa. |
| `etapas.sql` | As seis etapas do controle, uma view por etapa. Mostra quantas linhas cada etapa tem. |
| `pedido-nas-etapas.sql` | O pedido 687 passando pelas três primeiras etapas. |
| `controle-mensal.sql` | O controle por mês e transportadora, com a variação contra o mês anterior. |
| `frete-por-categoria.sql` | O frete dos pedidos de maio dividido pelas categorias. |
| `tentativas-do-mes.sql` | O frete das tentativas de cada mês, para bater com a fatura. |
| `testes.sql` | Os 30 testes do controle, com os números esperados do contrato. |
| `etapas-com-erros.sql` | As etapas com três erros que rodam sem erro de SQL. É o pedido 2 da prática. |
| `buraco-em-fevereiro.sql` | Tira as entregas da Rota Leve de fevereiro só durante a execução, sem mexer nos CSVs. É o pedido 3 da prática. |
| `minha-proposta.sql` | Em branco, para as views do exercício. |
| `meus-testes.sql` | Em branco, para os testes do exercício. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |

## Comandos

```bash
python3 projeto.py etapas.sql
python3 projeto.py etapas.sql pedido-nas-etapas.sql
python3 projeto.py etapas.sql controle-mensal.sql
python3 projeto.py etapas.sql frete-por-categoria.sql
python3 projeto.py etapas.sql tentativas-do-mes.sql
python3 projeto.py etapas.sql testes.sql
python3 projeto.py --falhas etapas-com-erros.sql testes.sql
python3 projeto.py buraco-em-fevereiro.sql etapas.sql controle-mensal.sql
python3 projeto.py etapas.sql minha-proposta.sql
python3 projeto.py etapas.sql minha-proposta.sql meus-testes.sql
```

A ordem dos arquivos importa: as views do `etapas.sql` precisam existir antes dos arquivos que usam elas. O `projeto.py` procura a base em `../dados`. Se ela estiver em outro lugar, passe `--dados` com o caminho.

`python3 projeto.py etapas.sql testes.sql` termina com `Todos os 30 testes passaram.` e código 0. Com o `etapas-com-erros.sql` no lugar, termina com `7 de 30 testes falharam.` e código 1. Com `--falhas`, o programa mostra só as linhas que não deram `ok`.

Para ver o código de saída depois de rodar, use `echo $?` no macOS e no Linux, ou `echo $LASTEXITCODE` no PowerShell do Windows.

Enquanto o `minha-proposta.sql` e o `meus-testes.sql` só tiverem comentários, o programa avisa `ainda não tem consulta` e sai com código 2.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
