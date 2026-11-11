# 38. Controle de frete: defesa

Os arquivos da aula «Controle de frete: defesa». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `projeto.py` | O mesmo da aula 37. Roda vários arquivos `.sql` em ordem, na mesma conexão, e mostra o resultado do último. Quando o último é um arquivo de testes, sai com código 1 se algum teste falhar. |
| `consultar.py` | O mesmo programa das outras aulas, para uma consulta solta. |
| `medir.py` | Roda os mesmos arquivos várias vezes e mostra o tempo, um resumo do resultado e quantas vezes o plano lê um CSV ou uma tabela na memória. |
| `contrato-do-frete.md` | O contrato de métricas da aula 36. |
| `etapas.sql` | As seis etapas do controle da aula 37, uma view por etapa. |
| `testes.sql` | Os 30 testes do controle da aula 37. |
| `controle-mensal.sql` | O controle por mês e transportadora da aula 37. |
| `pedidos-e-tentativas.sql` | Por que o frete dos pedidos de maio e o frete das tentativas de maio não batem. |
| `diferenca-entre-transportadoras.sql` | De onde vem a diferença de custo por pedido entre TransVale e Rota Leve em maio. |
| `meses-lado-a-lado.sql` | As duas transportadoras em cada mês fechado e nos cinco meses juntos. |
| `por-cidade.sql` | A diferença entre as transportadoras em cada cidade do cliente. |
| `carregar-tabelas.sql` | Lê cada CSV uma vez e guarda numa tabela na memória antes das etapas. Os CSVs não mudam. |
| `gravar-etapas.sql` | Grava as duas primeiras etapas como tabelas, para medir se vale a pena. |
| `base-cem-vezes.sql` | Monta na memória uma base com cada pedido repetido cem vezes, para medir com mais linhas. Os CSVs não mudam. |
| `minhas-consultas.sql` | Em branco, para as suas consultas da prática e do exercício. |
| `modelo-do-parecer.md` | O modelo do parecer executivo, para preencher. |
| `roteiro-da-defesa.md` | O roteiro da defesa técnica, para preencher. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |

## Comandos

```bash
python3 projeto.py etapas.sql pedidos-e-tentativas.sql
python3 projeto.py etapas.sql diferenca-entre-transportadoras.sql
python3 projeto.py etapas.sql meses-lado-a-lado.sql
python3 projeto.py etapas.sql por-cidade.sql
python3 projeto.py etapas.sql controle-mensal.sql
python3 projeto.py carregar-tabelas.sql
python3 projeto.py carregar-tabelas.sql etapas.sql testes.sql
python3 projeto.py base-cem-vezes.sql etapas.sql controle-mensal.sql
python3 medir.py etapas.sql testes.sql
python3 medir.py carregar-tabelas.sql etapas.sql testes.sql
python3 medir.py carregar-tabelas.sql etapas.sql gravar-etapas.sql testes.sql
python3 medir.py base-cem-vezes.sql etapas.sql controle-mensal.sql
python3 projeto.py carregar-tabelas.sql etapas.sql minhas-consultas.sql
```

A ordem dos arquivos importa. O `carregar-tabelas.sql` e o `base-cem-vezes.sql` vêm antes das etapas, porque trocam as tabelas que as etapas leem. O `gravar-etapas.sql` vem depois, porque grava o resultado delas. Os dois programas procuram a base em `../dados`. Se ela estiver em outro lugar, passe `--dados` com o caminho.

`python3 projeto.py carregar-tabelas.sql etapas.sql testes.sql` termina com `Todos os 30 testes passaram.` e código 0, como sem o `carregar-tabelas.sql`. É o comando de todo mês que a aula recomenda.

O `medir.py` roda 5 vezes, mais uma primeira rodada que fica fora da mediana. Para mudar, use `--vezes 10`. Os segundos dependem da sua máquina e do que mais está aberto nela. O resumo de 12 letras e as leituras do plano não dependem: com essa base, os testes dão o resumo `894a0e5f19db` com e sem o `carregar-tabelas.sql`.

Enquanto o `minhas-consultas.sql` só tiver comentários, o `projeto.py` avisa `ainda não tem consulta` e sai com código 2. Se o último SELECT tiver uma coluna chamada `resultado`, o `projeto.py` trata o arquivo como arquivo de testes; dê outro nome à coluna.

Para ver o código de saída depois de rodar, use `echo $?` no macOS e no Linux, ou `echo $LASTEXITCODE` no PowerShell do Windows.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
