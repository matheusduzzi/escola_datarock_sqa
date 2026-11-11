"""Roda uma consulta SQL contra os CSVs da pasta dados/ e imprime o resultado.

Cada CSV vira uma tabela com o nome do arquivo (clientes, pedidos, entregas).

    python3 consultar.py --sql "SELECT * FROM pedidos LIMIT 5"
    python3 consultar.py --arquivo respostas/tarefa-1.sql
    python3 consultar.py --dados ../dados --sql "SELECT COUNT(*) FROM itens_pedido"
"""
import argparse
import pathlib
import sys

import duckdb

AQUI = pathlib.Path(__file__).resolve().parent


def conectar(pasta_dados=None):
    pasta = pathlib.Path(pasta_dados) if pasta_dados else AQUI / "dados"
    con = duckdb.connect()
    for csv in sorted(pasta.glob("*.csv")):
        con.execute("CREATE VIEW %s AS SELECT * FROM read_csv_auto('%s', header=true)" % (csv.stem, csv.as_posix()))
    return con


def consultar(sql, pasta_dados=None):
    cur = conectar(pasta_dados).execute(sql)
    colunas = [d[0] for d in cur.description]
    return colunas, cur.fetchall()


def main():
    ap = argparse.ArgumentParser(description="Consulta SQL nos CSVs da pasta dados/.")
    grupo = ap.add_mutually_exclusive_group(required=True)
    grupo.add_argument("--sql", help="texto da consulta")
    grupo.add_argument("--arquivo", help="arquivo .sql com a consulta")
    ap.add_argument("--dados", help="outra pasta de CSVs (padrão: dados/ ao lado deste arquivo)")
    args = ap.parse_args()
    sql = args.sql if args.sql else pathlib.Path(args.arquivo).read_text(encoding="utf-8")
    sem_comentario = "\n".join(l.split("--")[0] for l in sql.splitlines()).strip()
    if not sem_comentario:
        print("O arquivo ainda não tem consulta. Escreva o SELECT abaixo dos comentários e rode de novo.")
        return 2
    try:
        colunas, linhas = consultar(sql, args.dados)
    except duckdb.Error as erro:
        print("A consulta não rodou. Mensagem do DuckDB:")
        print(str(erro))
        return 1
    larg = [max([len(str(c))] + [len("NULL" if l[i] is None else str(l[i])) for l in linhas]) for i, c in enumerate(colunas)]
    print("  ".join(str(c).ljust(larg[i]) for i, c in enumerate(colunas)))
    for l in linhas:
        print("  ".join(("NULL" if v is None else str(v)).ljust(larg[i]) for i, v in enumerate(l)))
    print("(%d linhas)" % len(linhas))
    return 0


if __name__ == "__main__":
    sys.exit(main())
