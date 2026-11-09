# 09. Agregações condicionais

Os arquivos da aula «Agregações condicionais». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa do diagnóstico. |
| `status-categoria.sql` | A consulta do Caio: uma linha por categoria e status, contando linhas de item. |
| `tres-taxas.sql` | A taxa de devolução por categoria, trocando uma regra por vez. |
| `indicadores.sql` | Os indicadores do Renato: pedidos, cancelados, devolvidos e vendas por categoria, com as taxas. |
| `loja-inteira.sql` | Os mesmos números para a loja inteira, ao lado da soma das categorias. |
| `else-zero.sql` | O que o `ELSE 0` faz dentro do `COUNT` e do `AVG`. |
| `sem-filter.sql` | Os indicadores do `indicadores.sql` escritos com `CASE` dentro do `SUM`, sem `FILTER`. |
| `divisao.sql` | A mesma taxa com divisão inteira e com divisão decimal. |
| `ficha-indicadores.md` | A ficha do exercício. Salve uma cópia com o seu nome. |
| `meus-indicadores.sql` | O arquivo da sua consulta do exercício. |

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo status-categoria.sql
python3 consultar.py --dados ../dados --arquivo tres-taxas.sql
python3 consultar.py --dados ../dados --arquivo indicadores.sql
python3 consultar.py --dados ../dados --arquivo loja-inteira.sql
python3 consultar.py --dados ../dados --arquivo else-zero.sql
python3 consultar.py --dados ../dados --arquivo sem-filter.sql
python3 consultar.py --dados ../dados --arquivo divisao.sql
python3 consultar.py --dados ../dados --arquivo meus-indicadores.sql
```

O `indicadores.sql` mostra 5 linhas, uma por categoria. Em Eletro, `pct_devolvido` é `7.9`. O `sem-filter.sql` mostra exatamente a mesma saída.

Enquanto o `meus-indicadores.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Se o arquivo tiver vários comandos, o programa roda todos e mostra o resultado do último.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
