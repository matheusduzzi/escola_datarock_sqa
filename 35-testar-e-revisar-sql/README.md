# 35. Testar e revisar SQL

Os arquivos da aula «Testar e revisar SQL». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa do diagnóstico. |
| `fechamento-do-diego.sql` | O fechamento parcial de junho como o Diego mandou. A consulta que a aula revisa. |
| `testes-do-fechamento.sql` | Os 11 testes do fechamento: o esperado tirado das tabelas e o resultado de cada versão, lado a lado. |
| `fechamento-revisado.sql` | O fechamento depois da revisão. |
| `a-receber-vazio.sql` | Os pedidos do recorte sem pagamento aprovado e o a receber de cada um, com e sem `COALESCE`. |
| `trava-do-diego.sql` | Quatro testes que param a execução com `error()`, rodando sobre a versão do Diego. Sai com código 1 de propósito. |
| `trava-da-revisada.sql` | Os mesmos quatro testes sobre a versão revisada. Sai com código 0. |
| `linhas-antes-do-group-by.sql` | Quantas linhas cada pedido ganha no JOIN do Diego. É o pedido 1 da prática. |
| `fronteira-tres-jeitos.sql` | Três jeitos de escrever o período de 1º a 20 de junho. É o pedido 2 da prática. |
| `dinheiro-sem-arredondar.sql` | Pedidos com diferença comparando com `<>` e comparando em centavos. É o pedido 3 da prática. |
| `conciliacao-da-livia.sql` | A consulta do exercício, para você rodar antes de testar. |
| `modelo-de-testes.md` | O formato de cada família de teste: chave, total, valor vazio e fronteira. |
| `resposta.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo fechamento-do-diego.sql
python3 consultar.py --dados ../dados --arquivo testes-do-fechamento.sql
python3 consultar.py --dados ../dados --arquivo fechamento-revisado.sql
python3 consultar.py --dados ../dados --arquivo a-receber-vazio.sql
python3 consultar.py --dados ../dados --arquivo trava-do-diego.sql
python3 consultar.py --dados ../dados --arquivo trava-da-revisada.sql
python3 consultar.py --dados ../dados --arquivo linhas-antes-do-group-by.sql
python3 consultar.py --dados ../dados --arquivo fronteira-tres-jeitos.sql
python3 consultar.py --dados ../dados --arquivo dinheiro-sem-arredondar.sql
python3 consultar.py --dados ../dados --arquivo conciliacao-da-livia.sql
python3 consultar.py --dados ../dados --arquivo minhas-consultas.sql
```

O `testes-do-fechamento.sql` termina com a linha `testes que passaram`: `11` no esperado, `3` na coluna `diego` e `11` na `revisada`.

O `trava-do-diego.sql` mostra `A consulta não rodou` e a mensagem `teste falhou:` com os testes que falharam. É o que ele deve fazer: o teste parou a execução. O `trava-da-revisada.sql` mostra `os 4 testes passaram`.

Enquanto o `minhas-consultas.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Deixe uma consulta por vez no arquivo: se houver duas, o programa mostra só o resultado da última.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
