"""Mostra o plano que o DuckDB monta para a última consulta de um arquivo .sql.

    python3 plano.py --dados ../dados --arquivo uma-consulta.sql
    python3 plano.py --dados ../dados --arquivo uma-consulta.sql --real
    python3 plano.py --dados ../dados --arquivo uma-consulta.sql --logico

Sem opção, mostra o plano físico, com a estimativa de linhas de cada operador. A consulta não roda.
Com --real, a consulta roda (EXPLAIN ANALYZE) e aparecem também as linhas que cada operador produziu.
Com --logico, mostra o plano lógico antes e depois do otimizador. A consulta não roda.

Cada linha é um operador. O recuo mostra quem alimenta quem: um operador recebe as linhas
dos operadores logo abaixo dele, com um recuo a mais. Leia de baixo para cima.
O tempo de cada operador fica de fora: ele muda de uma execução para outra e de uma máquina para outra.
As instruções antes da última (um ATTACH, por exemplo) rodam antes, como no consultar.py.

É o plano.py da aula 31. Na leitura de uma tabela, o detalhe agora mostra também o tipo de leitura
(Sequential Scan ou Index Scan). Na leitura de arquivos Parquet, mostra o filtro de pasta e quantos
arquivos foram lidos.
"""
import argparse
import json
import pathlib
import sys

import duckdb

from consultar import conectar

LARGURA_DETALHE = 130
LARGURA_COLUNAS = 40
CHAVES = ("Join Type", "Conditions", "Expression", "Expressions", "Filters", "Groups", "Aggregates", "Order By")


def nome(no):
    return (no.get("name") or no.get("operator_name") or no.get("operator_type") or "?").strip()


def leitura(no):
    return nome(no).startswith(("READ_CSV", "READ_PARQUET", "SEQ_SCAN", "TABLE_SCAN"))


def juntar(valor):
    if isinstance(valor, list):
        valor = ", ".join(str(v) for v in valor)
    return " ".join(str(valor).split())


def detalhe(no):
    info = no.get("extra_info") or {}
    filhos = no.get("children", [])
    if leitura(no):
        colunas = juntar(info.get("Projections") or "")
        if len(colunas) > LARGURA_COLUNAS:
            colunas = colunas[:LARGURA_COLUNAS - 3] + "..."
        arquivos = ""
        if info.get("Total Files Read"):
            arquivos = "arquivos lidos: %s" % info["Total Files Read"]
        elif info.get("Scanning Files"):
            arquivos = "arquivos: %s" % info["Scanning Files"]
        partes = [p for p in (juntar(info.get("Type") or ""), arquivos, colunas, juntar(info.get("File Filters") or ""),
                              juntar(info.get("Filters") or "")) if p]
    elif nome(no) == "PROJECTION":
        # Só mostra as colunas quando a projeção é o que diz qual arquivo foi lido (plano lógico).
        abaixo = filhos[0] if len(filhos) == 1 else {}
        sem_colunas = leitura(abaixo) and not (abaixo.get("extra_info") or {}).get("Projections")
        partes = [juntar(info["Expressions"])] if sem_colunas and info.get("Expressions") else []
    else:
        partes = [juntar(info[c]) for c in CHAVES if info.get(c)]
    texto = "; ".join(partes)
    return texto if len(texto) <= LARGURA_DETALHE else texto[:LARGURA_DETALHE - 3] + "..."


def estimativa(no):
    valor = (no.get("extra_info") or {}).get("Estimated Cardinality")
    return "~" + str(valor) if valor not in (None, "") else ""


def linhas_da_arvore(no, nivel, real):
    if nome(no) == "EXPLAIN_ANALYZE":
        for filho in no.get("children", []):
            yield from linhas_da_arvore(filho, nivel, real)
        return
    linha = ["  " * nivel + nome(no), estimativa(no)]
    if real:
        linha.append(str(no.get("operator_cardinality", "")))
    yield linha + [detalhe(no)]
    for filho in no.get("children", []):
        yield from linhas_da_arvore(filho, nivel + 1, real)


def imprimir(raizes, real=False):
    cab = ["operador", "estimado"] + (["real"] if real else []) + ["detalhe"]
    linhas = [l for r in raizes for l in linhas_da_arvore(r, 0, real)]
    larg = [max([len(cab[i])] + [len(l[i]) for l in linhas]) for i in range(len(cab))]
    print("  ".join(c.ljust(larg[i]) for i, c in enumerate(cab)).rstrip())
    for l in linhas:
        print("  ".join(v.ljust(larg[i]) for i, v in enumerate(l)).rstrip())
    print("(%d operadores)" % len(linhas))


def raizes(texto):
    dado = json.loads(texto)
    return dado if isinstance(dado, list) else dado.get("children", [])


def main():
    ap = argparse.ArgumentParser(description="Plano do DuckDB para a última consulta de um arquivo .sql.")
    ap.add_argument("--arquivo", required=True, help="arquivo .sql; o plano é o da última instrução")
    ap.add_argument("--dados", help="outra pasta de CSVs (padrão: dados/ ao lado deste arquivo)")
    modo = ap.add_mutually_exclusive_group()
    modo.add_argument("--real", action="store_true", help="roda a consulta e mostra as linhas de cada operador")
    modo.add_argument("--logico", action="store_true", help="mostra o plano lógico antes e depois do otimizador")
    args = ap.parse_args()
    sql = pathlib.Path(args.arquivo).read_text(encoding="utf-8")
    try:
        con = conectar(args.dados)
        instrucoes = con.extract_statements(sql)
        if not instrucoes:
            print("O arquivo ainda não tem consulta. Escreva o SELECT abaixo dos comentários e rode de novo.")
            return 2
        for instrucao in instrucoes[:-1]:
            con.execute(instrucao.query)
        ultima = instrucoes[-1].query
        if args.logico:
            con.execute("SET explain_output = 'all'")
            planos = dict(con.execute("EXPLAIN (FORMAT json) " + ultima).fetchall())
        else:
            prefixo = "EXPLAIN (ANALYZE, FORMAT json) " if args.real else "EXPLAIN (FORMAT json) "
            _, texto = con.execute(prefixo + ultima).fetchall()[-1]
    except duckdb.Error as erro:
        print("A consulta não rodou. Mensagem do DuckDB:")
        print(str(erro))
        return 1
    if args.logico:
        print("plano lógico, antes do otimizador")
        imprimir(raizes(planos["logical_plan"]))
        print()
        print("plano lógico, depois do otimizador")
        imprimir(raizes(planos["logical_opt"]))
    else:
        imprimir(raizes(texto), args.real)
    return 0


if __name__ == "__main__":
    sys.exit(main())
