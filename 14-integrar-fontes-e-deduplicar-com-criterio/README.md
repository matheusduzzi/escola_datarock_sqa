# 14. Integrar fontes e deduplicar com critério

Os arquivos da aula «Integrar fontes e deduplicar com critério». Rode os comandos de dentro desta pasta. Os cadastros da aula e do exercício estão em `dados/`, nesta pasta, e o `consultar.py` lê essa pasta sem precisar de `--dados`. Cada CSV vira uma tabela com o nome do arquivo.

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## Os cadastros

| Arquivo | Uma linha é | Colunas |
|---|---|---|
| `dados/site.csv` | um cliente com conta no site (40 linhas) | `id_cliente`, `nome`, `email`, `telefone`, `cidade`, `atualizado_em` |
| `dados/loja.csv` | um cadastro feito no caixa da loja (30 linhas) | `id_loja`, `nome`, `email`, `telefone`, `cidade`, `atualizado_em` |
| `dados/evento.csv` | uma presença no evento de 13/06/2026 na loja (15 linhas). É do exercício. | `id_evento`, `nome`, `email`, `telefone`, `cidade`, `atualizado_em` |

O `id_cliente` do site é o mesmo da base compartilhada em `../dados`, com a mesma cidade. Os pedidos da base continuam ligados a ele. O `atualizado_em` é o dia em que a linha foi escrita ou mexida pela última vez. E-mail, telefone ou cidade vazios aparecem como `NULL`.

Os CSVs já vêm prontos. Se você mexer neles e quiser voltar ao original, rode `python3 gerar.py` dentro de `dados/`. A saída é `site=40 loja=30 evento=15`.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa das outras aulas. |
| `contar.sql` | A primeira conta: as listas empilhadas, o `UNION` e os nomes diferentes. |
| `uma-pessoa.sql` | As três linhas da Ana Paula Souza, como chegaram. |
| `chaves.sql` | As mesmas linhas com o e-mail, o telefone e o primeiro nome limpos. |
| `pares.sql` | Quantas linhas da loja acharam um cliente do site, por regra. |
| `por-nome.sql` | Onde a conta por nome erra: mesmo nome com duas pessoas, uma pessoa com dois nomes. |
| `consolidar.sql` | A lista com uma linha por pessoa. |
| `rastro.sql` | De onde veio o telefone e a cidade de cada pessoa, e que linhas formaram cada uma. |
| `conferir.sql` | As contas que mostram que ninguém sumiu nem foi inventado. |
| `uma-linha.sql` | Os pares de algumas linhas da loja com o site. É da prática guiada. |
| `nome-e-cidade.sql` | Os pares que uma regra por nome e cidade acrescentaria. É da prática guiada. |
| `com-evento.sql`, `conferir-com-evento.sql` | Os arquivos do exercício. Salve uma cópia de cada um com o seu nome. |

## Comandos

```bash
python3 consultar.py --arquivo contar.sql
python3 consultar.py --arquivo uma-pessoa.sql
python3 consultar.py --arquivo chaves.sql
python3 consultar.py --arquivo pares.sql
python3 consultar.py --arquivo por-nome.sql
python3 consultar.py --arquivo consolidar.sql
python3 consultar.py --arquivo rastro.sql
python3 consultar.py --arquivo conferir.sql
python3 consultar.py --arquivo uma-linha.sql
python3 consultar.py --arquivo nome-e-cidade.sql
python3 consultar.py --arquivo com-evento.sql
python3 consultar.py --arquivo conferir-com-evento.sql
```

O `contar.sql` mostra `70` linhas empilhadas, `70` com `UNION` e `51` nomes sem acento. O `consolidar.sql` termina em `(51 linhas)`. No `conferir.sql`, as duas primeiras contas dão `70` e a de pessoas dá `51`.

Os dois arquivos do exercício, antes de você escrever neles, mostram `O arquivo ainda não tem consulta.` É de propósito: a consulta é sua.

Para a prática guiada, faça uma cópia do arquivo antes de mudar. No `rastro.sql`, a aula pede uma linha `WHERE` logo abaixo de `FROM consolidado`. Não edite os CSVs da pasta `dados/`.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
