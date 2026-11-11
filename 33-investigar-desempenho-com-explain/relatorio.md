# Relatório de medição: o relatório do mês nos arquivos por mês

Nome:

## 1. Pergunta

(Uma frase: o que você quer saber.)

## 2. Configuração

Copie a parte `configuração` da saída do `medir.py`. Use o mesmo número de threads em todas as medidas.

```text

```

Outros programas abertos durante a medida:

## 3. Volume

| | 3 milhões | 9 milhões |
|---|---|---|
| Linhas de `itens_historico` | | |
| Linhas de `itens_embaralhados` | | |
| Tamanho do `historico.duckdb` | | |
| Arquivos e tamanho de `historico_por_mes/` | | |
| Índices | | |
| Linhas de maio de 2026 | | |

Como o volume foi montado:

## 4. Consultas e resultado

| Consulta | Impressão digital com 3 milhões | Impressão digital com 9 milhões |
|---|---|---|
| `relatorio-do-mes.sql` | | |
| `relatorio-do-mes-embaralhado.sql` | | |
| `relatorio-por-arquivo.sql` | | |

## 5. Plano

| Consulta | Tipo de leitura ou arquivos lidos | Linhas que saíram da leitura |
|---|---|---|
| `relatorio-do-mes.sql` | | |
| `relatorio-por-arquivo.sql` | | |

## 6. Medição

Rodadas, aquecimento e medidas por rodada:

### 3 milhões

| Consulta | Medição | Mediana (ms) | Menor | Maior | Rodadas |
|---|---|---|---|---|---|
| `relatorio-do-mes.sql` | 1ª | | | | |
| `relatorio-do-mes.sql` | 2ª | | | | |
| `relatorio-do-mes-embaralhado.sql` | 1ª | | | | |
| `relatorio-do-mes-embaralhado.sql` | 2ª | | | | |
| `relatorio-por-arquivo.sql` | 1ª | | | | |
| `relatorio-por-arquivo.sql` | 2ª | | | | |

### 9 milhões

| Consulta | Medição | Mediana (ms) | Menor | Maior | Rodadas |
|---|---|---|---|---|---|
| `relatorio-do-mes.sql` | 1ª | | | | |
| `relatorio-do-mes.sql` | 2ª | | | | |
| `relatorio-do-mes-embaralhado.sql` | 1ª | | | | |
| `relatorio-do-mes-embaralhado.sql` | 2ª | | | | |
| `relatorio-por-arquivo.sql` | 1ª | | | | |
| `relatorio-por-arquivo.sql` | 2ª | | | | |

A ordem entre as três se repetiu nas duas medições?

## 7. Resultado e alcance

O que dá para dizer, para qual volume e qual máquina:

O que o plano explica:

O que não dá para dizer com essas medidas:

## Recomendação para a Lúcia

Mudar o relatório para os arquivos por mês? Para qual volume? O que medir de novo no servidor da loja antes de mudar?
