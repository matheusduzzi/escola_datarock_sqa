"""Mede quanto tempo a última consulta de um arquivo .sql leva, e diz em que condições mediu.

    python3 medir.py --dados ../dados --arquivo uma-consulta.sql
    python3 medir.py --dados ../dados --arquivo uma-consulta.sql --threads 1
    python3 medir.py --dados ../dados --arquivo uma-consulta.sql --perfil

A saída tem quatro partes:
- configuração: a máquina, o sistema, as versões do Python e do DuckDB e quantas threads a consulta usou;
- volume: o tamanho do historico.duckdb e as linhas de cada tabela, e os arquivos da pasta historico_por_mes/;
- resultado: quantas linhas a consulta retornou e uma impressão digital delas. Duas consultas com a
  mesma impressão digital retornaram as mesmas linhas, na mesma ordem;
- medição: o tempo de cada rodada, em milissegundos.

Cada rodada abre uma conexão nova, roda as instruções antes da última (um ATTACH, por exemplo),
roda a consulta algumas vezes sem contar (o aquecimento) e depois mede. A coluna "primeira" é a
primeira execução da rodada, a que encontra a conexão vazia. Ela não entra na mediana.

Com --perfil, abre mais uma conexão, faz o mesmo aquecimento e roda a consulta uma vez com o perfil
do DuckDB ligado. Mostra o tempo de cada operador e a latência, o tempo total da consulta medido
pelo DuckDB.
"""
import argparse
import hashlib
import json
import os
import pathlib
import platform
import statistics
import subprocess
import sys
import tempfile
import time

import duckdb

from consultar import conectar

MB = 1024 * 1024


def comando(*args):
    try:
        return subprocess.run(args, capture_output=True, text=True, timeout=5).stdout.strip()
    except (OSError, subprocess.SubprocessError):
        return ""


def maquina():
    processador, memoria = "", 0
    if sys.platform == "darwin":
        processador = comando("sysctl", "-n", "machdep.cpu.brand_string")
        memoria = int(comando("sysctl", "-n", "hw.memsize") or 0)
    elif sys.platform.startswith("linux"):
        try:
            for linha in open("/proc/cpuinfo", encoding="utf-8"):
                if linha.startswith("model name"):
                    processador = linha.split(":", 1)[1].strip()
                    break
            memoria = os.sysconf("SC_PAGE_SIZE") * os.sysconf("SC_PHYS_PAGES")
        except (OSError, ValueError):
            pass
    processador = processador or platform.processor() or platform.machine() or "não identificado"
    texto = "%s, %s núcleos" % (processador, os.cpu_count() or "?")
    if memoria:
        texto += ", %d GB de memória" % round(memoria / 1024 ** 3)
    return texto


def configuracao(threads):
    print("configuração")
    print("  máquina   %s" % maquina())
    if sys.platform == "darwin" and platform.mac_ver()[0]:
        sistema = "macOS %s" % platform.mac_ver()[0]
    else:
        sistema = "%s %s" % (platform.system(), platform.release())
    print("  sistema   %s (%s)" % (sistema, platform.machine()))
    print("  programas Python %s, DuckDB %s" % (platform.python_version(), duckdb.__version__))
    print("  threads   %d" % threads)


def volume():
    print("volume")
    banco = pathlib.Path("historico.duckdb")
    if not banco.is_file():
        print("  historico.duckdb    não existe nesta pasta")
    else:
        try:
            con = duckdb.connect(str(banco), read_only=True)
            tabelas = con.execute("SELECT table_name, estimated_size FROM duckdb_tables() ORDER BY table_name").fetchall()
            indices = con.execute("SELECT index_name FROM duckdb_indexes() ORDER BY index_name").fetchall()
            con.close()
            print("  historico.duckdb    %d MB; %s" % (round(banco.stat().st_size / MB),
                                                       ", ".join("%s %d linhas" % t for t in tabelas)))
            print("  índices             %s" % (", ".join(i[0] for i in indices) or "nenhum"))
        except duckdb.Error as erro:
            print("  historico.duckdb    não deu para abrir: %s" % str(erro).splitlines()[0])
    pasta = pathlib.Path("historico_por_mes")
    arquivos = list(pasta.rglob("*.parquet")) if pasta.is_dir() else []
    if arquivos:
        print("  historico_por_mes/  %d arquivos, %d MB" % (len(arquivos), round(sum(a.stat().st_size for a in arquivos) / MB)))
    else:
        print("  historico_por_mes/  não existe nesta pasta")


def preparar(dados, antes, threads):
    con = conectar(dados)
    con.execute("SET threads = %d" % threads)
    for instrucao in antes:
        con.execute(instrucao)
    return con


def rodada(dados, antes, consulta, aquecimento, vezes, threads):
    con = preparar(dados, antes, threads)
    tempos = []
    for i in range(aquecimento + vezes):
        inicio = time.perf_counter()
        con.execute(consulta).fetchall()
        tempos.append((time.perf_counter() - inicio) * 1000)
    con.close()
    return tempos[0], tempos[aquecimento:]


def perfil(dados, antes, consulta, aquecimento, threads):
    con = preparar(dados, antes, threads)
    for _ in range(aquecimento):
        con.execute(consulta).fetchall()
    with tempfile.TemporaryDirectory() as pasta:
        saida = pathlib.Path(pasta) / "perfil.json"
        con.execute("PRAGMA enable_profiling = 'json'")
        con.execute("PRAGMA profiling_output = '%s'" % saida.as_posix())
        con.execute(consulta).fetchall()
        con.execute("PRAGMA disable_profiling")
        dado = json.loads(saida.read_text(encoding="utf-8"))
    con.close()
    linhas = []

    def descer(no, nivel):
        nome = (no.get("operator_name") or no.get("operator_type") or "?").strip()
        linhas.append(("  " * nivel + nome, str(no.get("operator_cardinality", "")), no.get("operator_timing", 0) * 1000))
        for filho in no.get("children", []):
            descer(filho, nivel + 1)

    for filho in dado.get("children", []):
        descer(filho, 0)
    cab = ("operador", "linhas", "ms")
    larg = [max(len(cab[0]), *(len(l[0]) for l in linhas)), max(len(cab[1]), *(len(l[1]) for l in linhas))]
    print("perfil de uma execução (tempo de cada operador, em ms)")
    print("%s  %s  %s" % (cab[0].ljust(larg[0]), cab[1].ljust(larg[1]), cab[2]))
    for nome, card, ms in linhas:
        print("%s  %s  %.2f" % (nome.ljust(larg[0]), card.ljust(larg[1]), ms))
    print("soma dos operadores: %.2f ms" % sum(l[2] for l in linhas))
    print("latência da consulta: %.2f ms" % (dado.get("latency", 0) * 1000))


def positivo(minimo):
    def ler(texto):
        valor = int(texto)
        if valor < minimo:
            raise argparse.ArgumentTypeError("precisa ser %d ou mais" % minimo)
        return valor
    return ler


def main():
    ap = argparse.ArgumentParser(description="Mede o tempo da última consulta de um arquivo .sql.")
    ap.add_argument("--arquivo", required=True, help="arquivo .sql; a medida é da última instrução")
    ap.add_argument("--dados", help="outra pasta de CSVs (padrão: dados/ ao lado deste arquivo)")
    ap.add_argument("--rodadas", type=positivo(1), default=3, help="conexões novas, uma por rodada (padrão: 3)")
    ap.add_argument("--aquecimento", type=positivo(0), default=2, help="execuções sem contar no começo de cada rodada (padrão: 2)")
    ap.add_argument("--vezes", type=positivo(1), default=10, help="execuções medidas em cada rodada (padrão: 10)")
    ap.add_argument("--threads", type=positivo(1), default=4, help="threads do DuckDB (padrão: 4)")
    ap.add_argument("--perfil", action="store_true", help="mostra também o tempo de cada operador")
    args = ap.parse_args()
    sql = pathlib.Path(args.arquivo).read_text(encoding="utf-8")
    try:
        instrucoes = duckdb.connect().extract_statements(sql)
        if not instrucoes:
            print("O arquivo ainda não tem consulta. Escreva o SELECT abaixo dos comentários e rode de novo.")
            return 2
        antes = [i.query for i in instrucoes[:-1]]
        consulta = instrucoes[-1].query
        con = preparar(args.dados, antes, args.threads)
        resultado = con.execute(consulta).fetchall()
        con.close()
        rodadas = [rodada(args.dados, antes, consulta, args.aquecimento, args.vezes, args.threads)
                   for _ in range(args.rodadas)]
    except duckdb.Error as erro:
        print("A consulta não rodou. Mensagem do DuckDB:")
        print(str(erro))
        return 1
    configuracao(args.threads)
    volume()
    print("resultado")
    print("  %d linhas, impressão digital %s" % (len(resultado), hashlib.sha256(repr(resultado).encode()).hexdigest()[:8]))
    print("medição em ms: %d rodadas, cada uma numa conexão nova, %d de aquecimento e %d medidas por rodada"
          % (args.rodadas, args.aquecimento, args.vezes))
    print("rodada  primeira  mediana  menor  maior")
    for n, (primeira, tempos) in enumerate(rodadas, 1):
        print("%-6d  %-8.2f  %-7.2f  %-5.2f  %.2f" % (n, primeira, statistics.median(tempos), min(tempos), max(tempos)))
    todos = [t for _, tempos in rodadas for t in tempos]
    print("mediana das %d medidas: %.2f ms (menor %.2f, maior %.2f)"
          % (len(todos), statistics.median(todos), min(todos), max(todos)))
    if args.perfil:
        try:
            perfil(args.dados, antes, consulta, args.aquecimento, args.threads)
        except duckdb.Error as erro:
            print("O perfil não rodou. Mensagem do DuckDB:")
            print(str(erro))
            return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
