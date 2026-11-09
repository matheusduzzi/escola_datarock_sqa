# 18. Calendário e períodos sem movimento

Os arquivos da aula «Calendário e períodos sem movimento». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `por-categoria.sql` | A consulta do Caio: pedidos por mês e categoria, com as linhas de cada categoria juntas numa só. |
| `abril.sql` | Quantos pedidos abril teve, em quantos dias, e quantos itens de Esporte. |
| `media-esporte.sql` | A média mensal de pedidos de Esporte com três divisores diferentes. É o pedido 1 da prática. |
| `ate-dezembro.sql` | Esporte com uma tabela de meses de janeiro a dezembro, sem e com `COALESCE`. |
| `junho.sql` | Pedidos por mês, com os dias que a base cobre, os pedidos dos dias 1 a 20 e os pedidos por dia. É o pedido 2. |
| `frete-por-mes.sql` | Viagens, custos que faltam, soma e média do frete por mês. É o pedido 3. |
| `soma-de-nada.sql` | O que `COUNT`, `SUM` e `AVG` retornam quando não sobra nenhuma linha. |
| `cobertura.sql` | O primeiro e o último dia de cada coluna de data da base. |
| `briefing-frete.md` | O pedido da Marta para o exercício: como a entrega funciona e as três perguntas. |
| `semanas-do-caio.sql` | A consulta do Caio para a Marta: viagens, devoluções e frete por semana. |
| `folha-especificacao.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo por-categoria.sql
python3 consultar.py --dados ../dados --arquivo abril.sql
python3 consultar.py --dados ../dados --arquivo media-esporte.sql
python3 consultar.py --dados ../dados --arquivo ate-dezembro.sql
python3 consultar.py --dados ../dados --arquivo junho.sql
python3 consultar.py --dados ../dados --arquivo frete-por-mes.sql
python3 consultar.py --dados ../dados --arquivo soma-de-nada.sql
python3 consultar.py --dados ../dados --arquivo cobertura.sql
python3 consultar.py --dados ../dados --arquivo semanas-do-caio.sql
python3 consultar.py --dados ../dados --arquivo minhas-consultas.sql
```

O `por-categoria.sql` mostra Esporte com `5` linhas e as outras categorias com `6`. O `semanas-do-caio.sql` mostra `24` semanas, de 05/01 a 15/06.

O `minhas-consultas.sql`, antes de você escrever nele, mostra `O arquivo ainda não tem consulta.` É de propósito: as consultas são suas.

O programa mostra o resultado do último comando de cada arquivo. Para rodar várias consultas, rode uma de cada vez ou junte as respostas num `SELECT` só.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
