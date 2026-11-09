# 20. Consultar o passado corretamente

Os arquivos da aula «Consultar o passado corretamente». Rode os comandos de dentro desta pasta. Os pedidos, os itens, as entregas e o cadastro vêm da base da Loja Exemplo, em `../dados`; o dicionário está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md). Os dois históricos da aula ficam em `dados/`, nesta pasta.

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `dados/selo_cliente.csv` | O selo do programa de fidelidade: uma linha por cliente e mês, com `valido_de`, `valido_ate` e `registrado_em`. |
| `dados/historico_endereco.csv` | O histórico de cidade e UF, o mesmo da aula «Histórico e validade dos atributos». |
| `gasto-do-caio.sql` | A primeira versão do Caio: quanto um cliente de cada selo pede por mês, com o selo de hoje. |
| `maio.sql` | Só maio: o selo de hoje contra o selo que valia em maio. |
| `um-cliente.sql` | O cliente 46 mês a mês: o selo do mês, o selo de hoje e quanto ele pediu. |
| `gasto-por-selo.sql` | O número da Bia refeito, com o selo que valia em cada mês. |
| `selo-do-pedido.sql` | Cada pedido junta o selo do seu dia, e a conta de linhas antes de usar o resultado. |
| `data-do-evento.sql` | A cidade do cliente pelo dia do pedido e pelo dia da saída do volume. |
| `o-que-a-tela-mostrava.sql` | Os pedidos de 01/04 a 07/04: o selo que valia e o selo que já estava gravado no dia. |
| `asof.sql` | O selo do cliente 46 em duas datas, pela condição de período e pelo `ASOF JOIN`. |
| `pet-na-grade.sql` | A grade mês × categoria com uma data de entrada da categoria no catálogo. |
| `briefing-uf-selo.md` | O pedido do Renato para o exercício. |
| `caio-uf-selo.sql` | A versão do Caio para o quadro do Renato. |
| `minha-analise.sql` | O arquivo do exercício para a sua consulta. Salve uma cópia com o seu nome. |
| `minhas-respostas.md` | A folha do exercício. Salve uma cópia com o seu nome. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo gasto-do-caio.sql
python3 consultar.py --dados ../dados --arquivo maio.sql
python3 consultar.py --dados ../dados --arquivo um-cliente.sql
python3 consultar.py --dados ../dados --arquivo gasto-por-selo.sql
python3 consultar.py --dados ../dados --arquivo selo-do-pedido.sql
python3 consultar.py --dados ../dados --arquivo data-do-evento.sql
python3 consultar.py --dados ../dados --arquivo o-que-a-tela-mostrava.sql
python3 consultar.py --dados ../dados --arquivo asof.sql
python3 consultar.py --dados ../dados --arquivo pet-na-grade.sql
python3 consultar.py --dados ../dados --arquivo caio-uf-selo.sql
python3 consultar.py --dados ../dados --arquivo minha-analise.sql
```

O `gasto-do-caio.sql` mostra o ouro com `677.19` por mês, e o `gasto-por-selo.sql`, com `558.41`. O `selo-do-pedido.sql` mostra `900` pedidos na base, `900` linhas depois do `LEFT JOIN`, `0` pedidos com mais de um selo e `160` sem selo.

O `minha-analise.sql`, antes de você escrever nele, mostra `O arquivo ainda não tem consulta.` É de propósito: a consulta é sua.

Cada arquivo que usa um histórico começa criando a tabela dele, lida do CSV da pasta `dados/`. Não edite os dois CSVs: se quiser testar uma mudança, faça uma cópia e troque o caminho do `read_csv` na primeira linha.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
