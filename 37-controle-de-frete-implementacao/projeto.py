"""Roda os arquivos .sql do projeto em ordem, na mesma conexão, e imprime o resultado do último.

    python3 projeto.py etapas.sql
    python3 projeto.py etapas.sql controle-mensal.sql
    python3 projeto.py etapas.sql testes.sql
    python3 projeto.py --dados ../dados etapas.sql testes.sql
    python3 projeto.py --falhas etapas.sql testes.sql

Cada CSV da base vira uma tabela, como no consultar.py. As views criadas num arquivo valem
para os arquivos seguintes. Se o último resultado tem a coluna `resultado`, o programa sai com
código 1 quando alguma linha não diz `ok`: é assim que o arquivo de testes avisa que falhou.
Com --falhas, o programa mostra só as linhas que não deram `ok`.
"""
import argparse
import pathlib
import sys

import duckdb

from consultar import conectar

AQUI = pathlib.Path(__file__).resolve().parent


def sem_comentario(sql):
    return "\n".join(l.split("--")[0] for l in sql.splitlines()).strip()


def imprimir(colunas, linhas):
    larg = [max([len(str(c))] + [len("NULL" if l[i] is None else str(l[i])) for l in linhas]) for i, c in enumerate(colunas)]
    print("  ".join(str(c).ljust(larg[i]) for i, c in enumerate(colunas)))
    for l in linhas:
        print("  ".join(("NULL" if v is None else str(v)).ljust(larg[i]) for i, v in enumerate(l)))
    print("(%d linhas)" % len(linhas))


def main():
    ap = argparse.ArgumentParser(description="Roda arquivos .sql em ordem, na mesma conexão.")
    ap.add_argument("arquivos", nargs="+", help="arquivos .sql, na ordem em que devem rodar")
    ap.add_argument("--dados", default=str(AQUI.parent / "dados"), help="pasta dos CSVs (padrão: ../dados)")
    ap.add_argument("--falhas", action="store_true", help="mostra só as linhas de teste que não deram ok")
    args = ap.parse_args()
    con = conectar(args.dados)
    cur = None
    for nome in args.arquivos:
        sql = pathlib.Path(nome).read_text(encoding="utf-8")
        if not sem_comentario(sql):
            print("O arquivo %s ainda não tem consulta. Escreva o SQL abaixo dos comentários e rode de novo." % nome)
            return 2
        try:
            cur = con.execute(sql)
        except duckdb.Error as erro:
            print("O arquivo %s não rodou. Mensagem do DuckDB:" % nome)
            print(str(erro))
            return 1
    colunas = [d[0] for d in cur.description] if cur is not None and cur.description else []
    linhas = cur.fetchall() if colunas else []
    if not colunas or (colunas == ["Count"] and not linhas):
        # O DuckDB responde a um CREATE com uma coluna Count vazia: o último comando não foi um SELECT.
        print("O último arquivo não termina num SELECT. Ponha uma consulta no fim para ver o resultado.")
        return 2
    teste = "resultado" in colunas
    i = colunas.index("resultado") if teste else None
    imprimir(colunas, [l for l in linhas if l[i] != "ok"] if teste and args.falhas else linhas)
    if teste:
        falhas = sum(1 for l in linhas if l[i] != "ok")
        if falhas or not linhas:
            print("%d de %d testes falharam." % (falhas, len(linhas)) if linhas else "Nenhum teste rodou.")
            return 1
        print("Todos os %d testes passaram." % len(linhas))
    return 0


if __name__ == "__main__":
    sys.exit(main())
