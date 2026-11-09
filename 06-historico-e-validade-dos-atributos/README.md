# 06. Histórico e validade dos atributos

Os arquivos da aula «Histórico e validade dos atributos». Rode os comandos de dentro desta pasta. Os pedidos, os itens e o cadastro vêm da base da Loja Exemplo, em `../dados`; o dicionário está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md). Os dois históricos da aula ficam em `dados/`, nesta pasta.

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `dados/historico_endereco.csv` | O histórico de cidade e UF: uma linha por cliente e período, com `valido_de` e `valido_ate`. |
| `dados/condicao_comercial.csv` | O histórico de condição comercial como o sistema gravou. É o arquivo do exercício. |
| `estado-atual.sql` | Pega a linha que vale hoje (20/06/2026) para cada cliente e compara com o cadastro. |
| `um-cliente.sql` | Os pedidos do cliente 115 com a cidade do cadastro e a cidade do dia do pedido. |
| `janeiro-por-uf.sql` | As vendas de janeiro por UF, pela UF do cadastro e pela UF do dia do pedido. |
| `fronteira.sql` | O pedido 200, feito no dia em que o cliente mudou de cidade, buscado de três jeitos. |
| `checar-endereco.sql` | As seis regras do histórico de endereço e quantos clientes quebram cada uma. |
| `briefing-condicao.md` | O pedido do Renato para o exercício: como a loja trabalha, as decisões do semestre e as perguntas. |
| `folha-especificacao.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `checar-condicao.sql` | O arquivo do exercício para a consulta das regras da condição comercial. Salve uma cópia com o seu nome. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo estado-atual.sql
python3 consultar.py --dados ../dados --arquivo um-cliente.sql
python3 consultar.py --dados ../dados --arquivo janeiro-por-uf.sql
python3 consultar.py --dados ../dados --arquivo fronteira.sql
python3 consultar.py --dados ../dados --arquivo checar-endereco.sql
python3 consultar.py --dados ../dados --arquivo checar-condicao.sql
```

O `estado-atual.sql` mostra `120` clientes, `126` linhas de histórico e `120` linhas de hoje iguais ao cadastro. O `checar-endereco.sql` mostra zero nas seis regras.

O `checar-condicao.sql`, antes de você escrever nele, mostra `O arquivo ainda não tem consulta.` É de propósito: a consulta é sua.

Cada arquivo começa criando uma tabela com o histórico, lido do CSV da pasta `dados/`. Para rodar uma consulta em outro CSV, por exemplo a sua cópia corrigida do histórico de condição comercial, troque o caminho do `read_csv` na primeira linha. Não edite os dois CSVs originais: trabalhe numa cópia.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
