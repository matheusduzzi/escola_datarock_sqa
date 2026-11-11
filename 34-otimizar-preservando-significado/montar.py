"""Monta o histórico da aula no tamanho que você escolher.

    python3 montar.py --milhoes 3
    python3 montar.py --milhoes 9

Cria, nesta pasta, o arquivo historico.duckdb (duas tabelas com as mesmas linhas, em duas ordens)
e a pasta historico_por_mes/ (as mesmas linhas em arquivos Parquet, uma pasta por mês).
Rodar de novo apaga e recria os dois, e os índices que você criou somem junto.

O período é sempre o mesmo, de dezembro de 2021 a junho de 2026. O que muda com --milhoes é
quantos pedidos cabem nele: com 3 milhões de itens sai um pedido a cada 96 segundos, que é o
histórico da aula 32; com 9 milhões, um a cada 32 segundos. Os valores saem de uma regra fixa e
não são vendas de verdade: rodar duas vezes com o mesmo --milhoes gera as mesmas linhas.
"""
import argparse
import pathlib
import shutil
import sys

import duckdb

AQUI = pathlib.Path.cwd()
BANCO = AQUI / "historico.duckdb"
PASTA = AQUI / "historico_por_mes"
MB = 1024 * 1024

TABELA = """
CREATE TABLE itens_historico AS
SELECT i + 1                                                              AS id_item,
       i // 2 + 1                                                         AS id_pedido,
       (i // 2) * 7919 % 60001 + 1                                        AS id_cliente,
       TIMESTAMP '2021-12-01 00:00:00' + to_microseconds((i // 2) * {passo}) AS data_hora_pedido,
       ['site', 'app', 'loja'][1 + (i // 2) % 3]                          AS canal,
       CASE WHEN i % 2000 = 1999 THEN 'Presentes'
            ELSE ['Eletro', 'Casa', 'Moda', 'Esporte', 'Papelaria'][1 + i * 13 % 5] END AS categoria,
       CAST(10 + (i * 37 + i // 7) % 500 + (i * 11 % 100) / 100 AS DECIMAL(10,2)) AS valor
FROM range({itens}) AS t(i)
ORDER BY i
"""

EMBARALHADA = """
CREATE TABLE itens_embaralhados AS
SELECT * FROM itens_historico
ORDER BY id_item * 7919 % 3000017, id_item
"""

POR_MES = """
COPY (SELECT *, year(data_hora_pedido) AS ano, month(data_hora_pedido) AS mes FROM itens_historico)
TO 'historico_por_mes' (FORMAT parquet, PARTITION_BY (ano, mes), OVERWRITE_OR_IGNORE)
"""

CONFERENCIA = """
SELECT 'itens_historico' AS forma, COUNT(*) AS linhas, COUNT(DISTINCT id_pedido) AS pedidos,
       MIN(data_hora_pedido) AS primeiro, MAX(data_hora_pedido) AS ultimo
FROM itens_historico
UNION ALL
SELECT 'itens_embaralhados', COUNT(*), COUNT(DISTINCT id_pedido), MIN(data_hora_pedido), MAX(data_hora_pedido)
FROM itens_embaralhados
UNION ALL
SELECT 'historico_por_mes', COUNT(*), COUNT(DISTINCT id_pedido), MIN(data_hora_pedido), MAX(data_hora_pedido)
FROM read_parquet('historico_por_mes/*/*/*.parquet', hive_partitioning = true)
"""


def tamanho_pasta(pasta):
    arquivos = list(pasta.rglob("*.parquet"))
    return len(arquivos), sum(a.stat().st_size for a in arquivos)


def main():
    ap = argparse.ArgumentParser(description="Monta o histórico da aula com o volume escolhido.")
    ap.add_argument("--milhoes", type=int, default=3, help="milhões de itens, de 1 a 30 (padrão: 3)")
    args = ap.parse_args()
    if not 1 <= args.milhoes <= 30:
        print("Escolha --milhoes entre 1 e 30. Cada milhão ocupa cerca de 45 MB em disco.")
        return 2
    itens = args.milhoes * 1_000_000
    pedidos = itens // 2
    # Mesmo período para qualquer volume: o intervalo entre pedidos encolhe quando o volume cresce.
    passo = 96 * 1_500_000 * 1_000_000 // pedidos
    try:
        if BANCO.exists():
            BANCO.unlink()
        wal = BANCO.with_name(BANCO.name + ".wal")
        if wal.exists():
            wal.unlink()
        if PASTA.is_dir():
            shutil.rmtree(PASTA)
        con = duckdb.connect(str(BANCO))
        con.execute(TABELA.format(passo=passo, itens=itens))
        con.execute(EMBARALHADA)
        # Uma thread na gravação dos arquivos: sai um arquivo por mês, sempre o mesmo número de arquivos.
        con.execute("SET threads = 1")
        con.execute(POR_MES)
        con.execute("RESET threads")
        cur = con.execute(CONFERENCIA)
        colunas = [d[0] for d in cur.description]
        linhas = [[str(v) for v in l] for l in cur.fetchall()]
        con.close()
    except (duckdb.Error, OSError) as erro:
        print("O histórico não foi montado. Mensagem:")
        print(str(erro))
        return 1
    larg = [max([len(c)] + [len(l[i]) for l in linhas]) for i, c in enumerate(colunas)]
    print("  ".join(c.ljust(larg[i]) for i, c in enumerate(colunas)).rstrip())
    for l in linhas:
        print("  ".join(v.ljust(larg[i]) for i, v in enumerate(l)).rstrip())
    n, tam = tamanho_pasta(PASTA)
    print("historico.duckdb: %d MB; historico_por_mes/: %d arquivos, %d MB"
          % (round(BANCO.stat().st_size / MB), n, round(tam / MB)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
