"""Roda o mesmo arquivo .sql várias vezes e conta quantos resultados diferentes saíram.

Cada rodada abre uma conexão nova no DuckDB, como se você rodasse o consultar.py de novo.
Se a consulta não diz quem vem antes num empate, o resultado pode mudar de uma rodada para outra.

    python3 repetir.py --dados ../dados --arquivo vitrine-sem-desempate.sql
    python3 repetir.py --dados ../dados --arquivo vitrine-com-regra.sql --vezes 50
"""
import argparse
import pathlib
import sys

import duckdb

from consultar import consultar


def texto(colunas, linhas):
    valores = [["NULL" if v is None else str(v) for v in l] for l in linhas]
    larg = [max([len(c)] + [len(l[i]) for l in valores]) for i, c in enumerate(colunas)]
    cab = "  ".join(c.ljust(larg[i]) for i, c in enumerate(colunas)).rstrip()
    return cab, ["  ".join(v.ljust(larg[i]) for i, v in enumerate(l)).rstrip() for l in valores]


def main():
    ap = argparse.ArgumentParser(description="Roda um .sql várias vezes e conta os resultados diferentes.")
    ap.add_argument("--arquivo", required=True, help="arquivo .sql com a consulta")
    ap.add_argument("--dados", help="pasta dos CSVs (padrão: dados/ ao lado do consultar.py)")
    ap.add_argument("--vezes", type=int, default=20, help="quantas rodadas (padrão: 20)")
    args = ap.parse_args()
    sql = pathlib.Path(args.arquivo).read_text(encoding="utf-8")
    if not "\n".join(l.split("--")[0] for l in sql.splitlines()).strip():
        print("O arquivo ainda não tem consulta. Escreva o SELECT abaixo dos comentários e rode de novo.")
        return 2
    resultados = []
    try:
        for _ in range(max(args.vezes, 2)):
            colunas, linhas = consultar(sql, args.dados)
            resultados.append(tuple(tuple(l) for l in linhas))
    except duckdb.Error as erro:
        print("A consulta não rodou. Mensagem do DuckDB:")
        print(str(erro))
        return 1
    diferentes = sorted(set(resultados))
    print("%d rodadas. Resultados diferentes: %d." % (len(resultados), len(diferentes)))
    if len(diferentes) == 1:
        print("A lista saiu igual em todas as rodadas.")
        return 0
    if len({len(r) for r in diferentes}) > 1:
        print("O número de linhas mudou entre as rodadas.")
        return 0
    todas = [l for r in diferentes for l in r]
    cab, _ = texto(colunas, todas)
    print("Linhas que mudaram de uma rodada para outra:")
    print("      " + cab)
    for i in range(len(diferentes[0])):
        variantes = sorted({r[i] for r in diferentes}, key=lambda l: [str(v) for v in l])
        if len(variantes) > 1:
            _, linhas = texto(colunas, list(variantes) + todas)
            print("linha %d" % (i + 1))
            for l in linhas[:len(variantes)]:
                print("      " + l)
    return 0


if __name__ == "__main__":
    sys.exit(main())
