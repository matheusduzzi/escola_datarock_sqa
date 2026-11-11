# Modelo da consulta de comparação

A consulta que prova se duas versões retornam o mesmo. Troque os comentários pelas duas consultas inteiras, sem o `ATTACH` e sem o `;` do fim. As colunas precisam estar na mesma ordem nas duas.

```sql
ATTACH 'historico.duckdb' AS hist (READ_ONLY);
WITH original AS (
    -- a consulta original
), nova AS (
    -- a consulta reescrita
), so_original AS (
    SELECT * FROM original EXCEPT ALL SELECT * FROM nova
), so_nova AS (
    SELECT * FROM nova EXCEPT ALL SELECT * FROM original
)
SELECT 'linhas na original' AS conta, COUNT(*) AS n FROM original
UNION ALL SELECT 'linhas na nova', COUNT(*) FROM nova
UNION ALL SELECT 'só na original', COUNT(*) FROM so_original
UNION ALL SELECT 'só na nova', COUNT(*) FROM so_nova;
```

Para ver as linhas diferentes, e não só quantas são, troque o `SELECT` do fim por:

```sql
SELECT 'só na original' AS lado, * FROM so_original
UNION ALL
SELECT 'só na nova', * FROM so_nova;
```

## Antes de dizer que as duas retornam o mesmo

| Pergunta | Onde ver |
|---|---|
| As duas têm o mesmo número de linhas? | `linhas na original` e `linhas na nova` |
| Nenhuma linha está só de um lado? | `só na original` e `só na nova` iguais a 0 |
| A ordem conta no relatório? Se sim, ela é a mesma? | a impressão digital do `medir.py` nas duas |
| Cada mudança vale em qualquer dado, ou só nos de hoje? | a regra de cada mudança e uma contagem da premissa no histórico |
| O que os dados de hoje não têm muda alguma coisa? | uma consulta com itens escritos à mão (`VALUES`) |

Só depois disso, meça as duas com o `medir.py`, nas mesmas condições.
