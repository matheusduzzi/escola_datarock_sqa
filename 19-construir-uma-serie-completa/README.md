# 19. Construir uma série completa

Os arquivos da aula «Construir uma série completa». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `serie-do-caio.sql` | A segunda versão do Caio: tabela de meses com LEFT JOIN nos pedidos por mês e categoria. As linhas de cada categoria aparecem juntas numa linha só. |
| `grade.sql` | A grade da série: os meses com as categorias do catálogo, ainda sem pedido. |
| `contar-depois.sql` | A grade com os itens juntados direto e três jeitos de contar. É o pedido 2 da prática. |
| `filtro-esporte.sql` | Só Esporte, com o filtro de categoria em dois lugares. |
| `cobertura-meses.sql` | O calendário de dias da base agrupado por mês: dias do mês, dias na base e situação. |
| `serie-completa.sql` | A série da reunião: uma linha por mês e categoria, com os pedidos e a cobertura. |
| `checar-serie.sql` | Perguntas sobre a série, com a resposta de cada uma. É o pedido 3 da prática. |
| `dias-com-esporte.sql` | Os dias que a base cobre e os dias com pedido de Esporte, mês a mês. |
| `briefing-semanal.md` | O pedido da Lúcia para o exercício: a série por semana e as três perguntas. |
| `semanal-do-caio.sql` | A consulta do Caio para a série semanal, resumida por categoria. |
| `minha-serie.sql` | Um arquivo em branco para a sua série semanal. |
| `minhas-respostas.md` | A folha do exercício. Salve uma cópia com o seu nome. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo serie-do-caio.sql
python3 consultar.py --dados ../dados --arquivo grade.sql
python3 consultar.py --dados ../dados --arquivo contar-depois.sql
python3 consultar.py --dados ../dados --arquivo filtro-esporte.sql
python3 consultar.py --dados ../dados --arquivo cobertura-meses.sql
python3 consultar.py --dados ../dados --arquivo serie-completa.sql
python3 consultar.py --dados ../dados --arquivo checar-serie.sql
python3 consultar.py --dados ../dados --arquivo dias-com-esporte.sql
python3 consultar.py --dados ../dados --arquivo semanal-do-caio.sql
python3 consultar.py --dados ../dados --arquivo minha-serie.sql
```

O `serie-do-caio.sql` mostra Esporte com `5` linhas e as outras categorias com `6`. O `serie-completa.sql` termina com `(30 linhas)`.

O `minha-serie.sql`, antes de você escrever nele, mostra `O arquivo ainda não tem consulta.` É de propósito: a série é sua.

O programa mostra o resultado do último comando de cada arquivo. O `checar-serie.sql` usa isso: primeiro guarda a série como uma view, depois faz as perguntas sobre ela. Você pode fazer o mesmo com a sua série semanal.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
