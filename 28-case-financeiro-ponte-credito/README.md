# 28. Case financeiro: análise de safras

Os arquivos da aula «Case financeiro: análise de safras». Rode os comandos de dentro desta pasta. As consultas usam os dados da Ponte Crédito, que ficam em `dados/`, ao lado do `consultar.py`. O dicionário das tabelas e a data da extração estão em [dados/LEIA-ME.md](dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa do diagnóstico. |
| `dados/` | Os quatro CSVs da Ponte Crédito (`propostas`, `contratos`, `desembolsos`, `parcelas`), o `LEIA-ME.md` e o `gerar.py`, que monta os CSVs de novo. |
| `atraso-do-otavio.sql` | A tabela do Otávio: atraso de mais de 30 dias em qualquer parcela, por safra, até a extração. |
| `desembolso-com-join.sql` | A primeira versão do desembolso por mês, com o valor do contrato depois do JOIN. |
| `tres-totais.sql` | O total do JOIN, o liberado e o contratado, lado a lado. |
| `acumulado.sql` | O desembolso de cada mês e o acumulado desde julho de 2025. |
| `participacao-por-canal.sql` | Quanto o parceiro pesa no mês e no acumulado. |
| `checar-totais.sql` | Perguntas com resposta conhecida sobre o desembolso, o acumulado e a participação. |
| `parcelas-julgaveis.sql` | Em cada safra, até que parcela já venceu há mais de 30 dias. |
| `safras.sql` | Atraso nas três primeiras parcelas, só nas safras que já podem ser comparadas. |
| `safras-por-canal.sql` | A mesma régua, com o web e o parceiro lado a lado. |
| `checar-safras.sql` | Perguntas com resposta conhecida sobre a tabela de safras. |
| `contratado-e-liberado.sql` | O que foi contratado, o que foi liberado e o que falta liberar. É o pedido 1 da prática. |
| `tres-parcelas-sem-regua.sql` | A régua das três parcelas nas safras de 2026, sem olhar a idade. É o pedido 2 da prática. |
| `quando-amadurece.sql` | Quando cada safra de fora entra na comparação. É o pedido 3 da prática. |
| `consulta-do-otavio.sql` | A consulta do exercício, para você rodar antes de corrigir. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

```bash
python3 consultar.py --arquivo atraso-do-otavio.sql
python3 consultar.py --arquivo desembolso-com-join.sql
python3 consultar.py --arquivo tres-totais.sql
python3 consultar.py --arquivo acumulado.sql
python3 consultar.py --arquivo participacao-por-canal.sql
python3 consultar.py --arquivo checar-totais.sql
python3 consultar.py --arquivo parcelas-julgaveis.sql
python3 consultar.py --arquivo safras.sql
python3 consultar.py --arquivo safras-por-canal.sql
python3 consultar.py --arquivo checar-safras.sql
python3 consultar.py --arquivo contratado-e-liberado.sql
python3 consultar.py --arquivo tres-parcelas-sem-regua.sql
python3 consultar.py --arquivo quando-amadurece.sql
python3 consultar.py --arquivo consulta-do-otavio.sql
python3 consultar.py --arquivo minhas-consultas.sql
```

O `acumulado.sql` termina com `20514320` em junho de 2026, o mesmo total da tabela `desembolsos`. O `safras.sql` tem 12 linhas: oito safras com o percentual e quatro com `ainda não`. O `consulta-do-otavio.sql` imprime 24 linhas, uma por safra e canal.

Se quiser montar os CSVs de novo, rode `python3 dados/gerar.py`. Os arquivos saem iguais aos que vieram no kit.

Enquanto o `minhas-consultas.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Deixe uma consulta por vez no arquivo: se houver duas, o programa mostra só o resultado da última.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
