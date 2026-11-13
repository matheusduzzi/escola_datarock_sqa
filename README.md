# Kit do curso SQL analítico

Os arquivos que você usa nas aulas: os dados da Loja Exemplo, um programa para rodar SQL sobre eles e uma pasta por aula com o que a prática pede.

## Como o kit está organizado

| Pasta | O que tem |
|---|---|
| `dados/` | A base da Loja Exemplo: clientes, produtos, pedidos, itens, pagamentos e entregas. Ver [dados/LEIA-ME.md](dados/LEIA-ME.md). |
| `00-apresentacao/` | O diagnóstico: [diagnostico.md](00-apresentacao/diagnostico.md), os dados das quatro tarefas, os arquivos de resposta em branco, a [folha de respostas](00-apresentacao/minhas-respostas.md) e a [folha da sua ordem de estudo](00-apresentacao/ordem-de-estudo.md). |
| `NN-titulo/` | Uma pasta por aula, com o número e o título da aula. Elas entram no kit junto com as aulas. |

Cada pasta de aula tem um `consultar.py` e diz no próprio README de onde vêm os dados: da pasta `dados/` dela ou da base compartilhada em `../dados`. Os comandos das aulas são rodados de dentro da pasta da aula.

## Do que você precisa

- Python 3.9 ou mais novo. Se você ainda não instalou, a aula 03. Preparar o ambiente, de Primeiros passos em dados: SQL e Python, mostra como.
- O DuckDB para Python, na versão do `requirements.txt`. É o banco em que as consultas rodam: ele lê os CSVs direto, sem servidor.
- Um editor de texto para escrever os arquivos `.sql`. Se você usa o VS Code de Primeiros passos, serve.

Na pasta do kit, instale o DuckDB:

```bash
python3 -m pip install -r requirements.txt
```

E veja se funcionou, rodando o diagnóstico:

```bash
cd 00-apresentacao
python3 consultar.py --sql "SELECT COUNT(*) AS pedidos FROM pedidos"
```

A saída mostra `16` na coluna `pedidos` e `(1 linhas)` no fim. Se aparecer `No module named 'duckdb'`, o `pip` instalou em outro Python: rode `python3 -m pip install duckdb==1.4.5` com o mesmo `python3` que você usa para rodar o programa.

Para usar a base compartilhada de dentro de uma pasta de aula:

```bash
python3 consultar.py --dados ../dados --sql "SELECT status, COUNT(*) FROM pedidos GROUP BY status"
```

## SQL de outros bancos

As consultas do curso rodam no DuckDB. Quando uma aula compara com PostgreSQL, MySQL ou BigQuery, ela diz o banco e a versão. Uma sintaxe que funciona em um banco pode não funcionar em outro.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.

## Licença

A licença de uso e redistribuição do kit ainda vai ser definida pela Escola Datarock. Até lá, use os arquivos para estudar o curso.

## Aulas com arquivos neste kit

| Pasta | Aula |
|---|---|
| [00-apresentacao/](00-apresentacao/) | Apresentação |
| [01-onde-a-consulta-roda/](01-onde-a-consulta-roda/) | Onde a consulta roda |
| [02-ler-um-esquema-e-definir-granularidade/](02-ler-um-esquema-e-definir-granularidade/) | Ler um esquema e definir granularidade |
| [03-modelagem-conceitual-logica-e-fisica/](03-modelagem-conceitual-logica-e-fisica/) | Modelagem conceitual, lógica e física |
| [04-normalizacao-e-anomalias/](04-normalizacao-e-anomalias/) | Normalização e anomalias |
| [05-do-operacional-ao-dimensional/](05-do-operacional-ao-dimensional/) | Do operacional ao dimensional |
| [06-historico-e-validade-dos-atributos/](06-historico-e-validade-dos-atributos/) | Histórico e validade dos atributos |
| [07-warehouse-lake-e-responsabilidade-da-camada/](07-warehouse-lake-e-responsabilidade-da-camada/) | Warehouse, lake e responsabilidade da camada |
| [08-case-coalesce-e-regras-explicitas/](08-case-coalesce-e-regras-explicitas/) | CASE, COALESCE e regras explícitas |
| [09-agregacoes-condicionais/](09-agregacoes-condicionais/) | Agregações condicionais |
| [10-subqueries-e-ctes/](10-subqueries-e-ctes/) | Subqueries e CTEs |
| [11-construir-e-conferir-ctes/](11-construir-e-conferir-ctes/) | Construir e conferir CTEs |
| [12-existencia-e-ausencia-com-exists/](12-existencia-e-ausencia-com-exists/) | Existência e ausência com EXISTS |
| [13-operacoes-de-conjuntos/](13-operacoes-de-conjuntos/) | Operações de conjuntos |
| [14-integrar-fontes-e-deduplicar-com-criterio/](14-integrar-fontes-e-deduplicar-com-criterio/) | Integrar fontes e deduplicar com critério |
| [15-juntar-multiplos-fatos/](15-juntar-multiplos-fatos/) | Juntar múltiplos fatos |
| [16-datas-periodos-e-limites/](16-datas-periodos-e-limites/) | Datas, períodos e limites |
| [17-texto-tipos-e-conversoes/](17-texto-tipos-e-conversoes/) | Texto, tipos e conversões |
| [18-calendario-e-periodos-sem-movimento/](18-calendario-e-periodos-sem-movimento/) | Calendário e períodos sem movimento |
| [19-construir-uma-serie-completa/](19-construir-uma-serie-completa/) | Construir uma série completa |
| [20-consultar-o-passado-corretamente/](20-consultar-o-passado-corretamente/) | Consultar o passado corretamente |
| [21-particao-ordenacao-e-frame/](21-particao-ordenacao-e-frame/) | Partição, ordenação e frame |
| [22-ranking-e-desempate/](22-ranking-e-desempate/) | Ranking e desempate |
| [23-comparar-linhas-com-lag-e-lead/](23-comparar-linhas-com-lag-e-lead/) | Comparar linhas com LAG e LEAD |
| [24-rows-range-e-fronteiras/](24-rows-range-e-fronteiras/) | ROWS, RANGE e fronteiras |
| [25-acumulado-e-participacao/](25-acumulado-e-participacao/) | Acumulado e participação |
| [26-media-movel-com-calendario/](26-media-movel-com-calendario/) | Média móvel com calendário |
| [27-combinar-janelas-e-etapas/](27-combinar-janelas-e-etapas/) | Combinar janelas e etapas |
| [28-case-financeiro-ponte-credito/](28-case-financeiro-ponte-credito/) | Case financeiro: Ponte Crédito |
| [29-views-e-materializacao/](29-views-e-materializacao/) | Views e materialização |
| [30-organizar-camadas-de-consulta/](30-organizar-camadas-de-consulta/) | Organizar camadas de consulta |
| [31-plano-logico-e-fisico/](31-plano-logico-e-fisico/) | Plano lógico e físico |
| [32-indices-particionamento-e-organizacao-dos-dados/](32-indices-particionamento-e-organizacao-dos-dados/) | Índices, particionamento e organização dos dados |
| [33-investigar-desempenho-com-explain/](33-investigar-desempenho-com-explain/) | Investigar desempenho com EXPLAIN |
| [34-otimizar-preservando-significado/](34-otimizar-preservando-significado/) | Otimizar preservando significado |
| [35-testar-e-revisar-sql/](35-testar-e-revisar-sql/) | Testar e revisar SQL |
| [36-controle-de-frete-briefing-e-modelo/](36-controle-de-frete-briefing-e-modelo/) | Controle de frete: briefing e modelo |
| [37-controle-de-frete-implementacao/](37-controle-de-frete-implementacao/) | Controle de frete: implementação |
| [38-controle-de-frete-defesa/](38-controle-de-frete-defesa/) | Controle de frete: defesa |
