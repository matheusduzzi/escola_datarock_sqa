"""Mede quanto tempo um conjunto de arquivos .sql leva para rodar e resume o resultado do último.

    python3 medir.py etapas.sql testes.sql
    python3 medir.py carregar-tabelas.sql etapas.sql testes.sql
    python3 medir.py --vezes 10 etapas.sql controle-mensal.sql
    python3 medir.py --dados ../dados etapas.sql controle-mensal.sql

Cada rodada abre uma conexão nova e roda os arquivos em ordem, como o projeto.py. O tempo
conta da conexão até o fim do último arquivo, então o tempo de carregar as tabelas entra na
conta. A primeira rodada fica de fora da mediana porque o sistema ainda está abrindo os arquivos;
ela aparece separada.

O resumo do resultado são 12 letras calculadas a partir de todas as linhas do último arquivo.
Dois jeitos de rodar que dão o mesmo resultado dão as mesmas 12 letras. Uma diferença em
qualquer linha ou valor muda as letras.

Também mostra, no plano do último comando, quantas vezes o banco lê um CSV e quantas lê uma
tabela que já está na memória. O tempo depende da máquina: compare duas medições feitas na
mesma máquina, uma logo depois da outra.
"""
import argparse
import collections
import hashlib
import json
import pathlib
import statistics
import sys
import time

import duckdb

from consultar import conectar

AQUI = pathlib.Path(__file__).resolve().parent


def rodada(dados, sqls):
    inicio = time.perf_counter()
    con = conectar(dados)
    cur = None
    for sql in sqls:
        cur = con.execute(sql)
    linhas = cur.fetchall() if cur is not None and cur.description else []
    return time.perf_counter() - inicio, con, linhas


def contar_leituras(no, contagem):
    nome = (no.get("name") or no.get("operator_name") or "").strip()
    if nome.startswith("READ_CSV"):
        contagem["csv"] += 1
    elif nome in ("SEQ_SCAN", "TABLE_SCAN"):
        contagem["tabela"] += 1
    for filho in no.get("children", []):
        contar_leituras(filho, contagem)


def leituras_do_plano(con, sql):
    comandos = con.extract_statements(sql)
    if not comandos:
        return None
    plano = con.execute("EXPLAIN (FORMAT JSON) " + comandos[-1].query).fetchall()[0][1]
    contagem = collections.Counter()
    for no in json.loads(plano):
        contar_leituras(no, contagem)
    return contagem


def main():
    ap = argparse.ArgumentParser(description="Mede o tempo de arquivos .sql rodados em ordem.")
    ap.add_argument("arquivos", nargs="+", help="arquivos .sql, na ordem em que devem rodar")
    ap.add_argument("--dados", default=str(AQUI.parent / "dados"), help="pasta dos CSVs (padrão: ../dados)")
    ap.add_argument("--vezes", type=int, default=5, help="rodadas contadas na mediana (padrão: 5)")
    args = ap.parse_args()
    faltando = [a for a in args.arquivos if not pathlib.Path(a).is_file()]
    if faltando:
        print("Não achei o arquivo %s. Rode o comando de dentro da pasta da aula." % ", ".join(faltando))
        return 2
    sqls = [pathlib.Path(a).read_text(encoding="utf-8") for a in args.arquivos]
    try:
        primeira, _, _ = rodada(args.dados, sqls)
        tempos, resumos = [], set()
        for _ in range(max(args.vezes, 1)):
            t, con, linhas = rodada(args.dados, sqls)
            tempos.append(t)
            resumos.add(hashlib.sha256(repr(linhas).encode("utf-8")).hexdigest()[:12])
        leituras = leituras_do_plano(con, sqls[-1])
    except duckdb.Error as erro:
        print("Os arquivos não rodaram. Mensagem do DuckDB:")
        print(str(erro))
        return 1
    print("arquivos: %s" % " ".join(args.arquivos))
    print("primeira rodada: %.2f s (fora da mediana)" % primeira)
    print("rodadas: %d | mediana %.2f s | menor %.2f s | maior %.2f s"
          % (len(tempos), statistics.median(tempos), min(tempos), max(tempos)))
    print("resultado do último arquivo: %d linhas | resumo %s" % (len(linhas), " ".join(sorted(resumos))))
    if len(resumos) > 1:
        print("Atenção: o resultado mudou entre as rodadas.")
    if leituras is not None:
        print("leituras no plano do último comando: %d de CSV, %d de tabela na memória"
              % (leituras["csv"], leituras["tabela"]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
