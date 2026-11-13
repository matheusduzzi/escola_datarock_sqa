"""Gera a base da Loja Exemplo usada nas aulas de SQL analítico.

Só biblioteca padrão. Rodar duas vezes dá os mesmos arquivos, byte a byte.

    python3 gerar.py                 # escreve nesta pasta
    python3 gerar.py --saida /tmp/x  # escreve em outra pasta (usado na verificação)

Tabelas e grão:
- clientes:      uma linha por cliente cadastrado
- produtos:      uma linha por produto do catálogo
- pedidos:       uma linha por pedido (cabeçalho, sem valor: o valor vem dos itens)
- itens_pedido:  uma linha por item de um pedido (id_pedido, n_item)
- pagamentos:    uma linha por transação de pagamento; um pedido pode ter 0, 1 ou mais
- entregas:      uma linha por tentativa de entrega de um volume, ou pela volta de uma devolução

Os casos de borda que as aulas usam estão descritos fora do kit do aluno, para não
estragar os exercícios. O resumo impresso no fim traz as contagens principais.
"""
import argparse
import csv
import datetime as dt
import pathlib
import random

SEMENTE = 2026
INICIO = dt.datetime(2026, 1, 1)
FIM = dt.datetime(2026, 6, 20, 23, 59, 59)
N_CLIENTES = 120
N_SEM_PEDIDO = 8
N_PEDIDOS = 900

CIDADES = [("Campinas", "SP", 30), ("Sorocaba", "SP", 18), ("Jundiaí", "SP", 15),
           ("Piracicaba", "SP", 12), ("Ribeirão Preto", "SP", 12), ("Santos", "SP", 12),
           ("Limeira", "SP", 9), ("Bauru", "SP", 4), ("Curitiba", "PR", 8)]
CATEGORIAS = {
    "Eletro": [("Liquidificador", 189.9), ("Ventilador", 239.9), ("Batedeira", 279.0),
               ("Cafeteira", 159.9), ("Aspirador", 349.0), ("Sanduicheira", 99.9)],
    "Casa": [("Jogo de toalhas", 89.9), ("Panela", 129.9), ("Jogo de copos", 49.9),
             ("Luminária", 119.0), ("Organizador", 39.9), ("Cortina", 149.9)],
    "Papelaria": [("Caderno", 24.9), ("Agenda", 39.9), ("Estojo", 19.9),
                  ("Mochila", 159.0), ("Calculadora", 59.9), ("Marca-texto", 12.9)],
    "Esporte": [("Bola", 79.9), ("Garrafa térmica", 69.9), ("Tapete de yoga", 99.0),
                ("Halter", 119.9), ("Corda de pular", 29.9), ("Joelheira", 49.9)],
    "Beleza": [("Secador", 199.0), ("Escova", 34.9), ("Hidratante", 44.9),
               ("Protetor solar", 59.9), ("Perfume", 189.0), ("Chapinha", 169.0)],
}
TRANSPORTADORAS = {"TransVale": 14.0, "Rota Leve": 11.5}
# Horários fixos de alguns pedidos.
HORARIOS_FRONTEIRA = [dt.datetime(2026, 1, 31, 23, 58, 41), dt.datetime(2026, 2, 1, 0, 3, 12),
                      dt.datetime(2026, 3, 31, 23, 59, 30), dt.datetime(2026, 4, 1, 0, 0, 0),
                      dt.datetime(2026, 4, 30, 23, 59, 59), dt.datetime(2026, 5, 1, 0, 0, 1)]


def dinheiro(x):
    return "%.2f" % round(x + 1e-9, 2)


def gerar(saida):
    rng = random.Random(SEMENTE)
    saida.mkdir(parents=True, exist_ok=True)

    # clientes: os últimos cadastrados (junho) não compraram
    clientes = []
    i = 0
    for cidade, uf, n in CIDADES:
        for _ in range(n):
            i += 1
            clientes.append([i, "Cliente %03d" % i, cidade, uf, None])
    rng.shuffle(clientes)
    for pos, c in enumerate(clientes):
        if pos >= N_CLIENTES - N_SEM_PEDIDO:
            c[4] = dt.date(2026, 6, rng.randint(10, 20))
        else:
            c[4] = dt.date(2025, rng.randint(1, 12), rng.randint(1, 28))
    compradores = [c[0] for c in clientes[:N_CLIENTES - N_SEM_PEDIDO]]
    clientes.sort(key=lambda c: c[0])

    produtos = []
    pid = 0
    for cat, itens in CATEGORIAS.items():
        for nome, preco in itens:
            pid += 1
            produtos.append([pid, nome, cat, preco])
    nao_esporte = [p for p in produtos if p[2] != "Esporte"]

    # pedidos
    segundos = int((FIM - INICIO).total_seconds())
    horarios = sorted([INICIO + dt.timedelta(seconds=rng.randint(0, segundos))
                       for _ in range(N_PEDIDOS - len(HORARIOS_FRONTEIRA))] + HORARIOS_FRONTEIRA)
    pesos = [rng.choice([1, 1, 2, 3]) for _ in compradores]
    pedidos, itens, pagamentos, entregas = [], [], [], []
    id_pag = id_ent = 0
    for n, quando in enumerate(horarios, start=1):
        cliente = rng.choices(compradores, weights=pesos)[0]
        canal = rng.choices(["site", "app", "loja"], weights=[50, 35, 15])[0]
        r = rng.random()
        if quando >= dt.datetime(2026, 6, 15):
            status = "em_andamento" if r < 0.85 else "cancelado"
        else:
            status = "entregue" if r < 0.86 else ("cancelado" if r < 0.94 else "devolvido")
            if status == "devolvido" and quando >= dt.datetime(2026, 6, 1):
                status = "entregue"
        pedidos.append([n, cliente, quando.strftime("%Y-%m-%d %H:%M:%S"), canal, status])

        # itens
        catalogo = nao_esporte if quando.month == 4 else produtos
        n_itens = rng.choices([1, 2, 3, 4], weights=[55, 25, 13, 7])[0]
        total = 0.0
        for k in range(1, n_itens + 1):
            p = rng.choice(catalogo)
            qtd = rng.choices([1, 2, 3], weights=[75, 20, 5])[0]
            preco = p[3] if rng.random() < 0.85 else round(p[3] * 0.9, 2)
            d = rng.random()
            desconto = None if d < 0.80 else (0.0 if d < 0.88 else round(qtd * preco * 0.1, 2))
            itens.append([n, k, p[0], qtd, preco, desconto])
            total += qtd * preco - (desconto or 0.0)
        total = round(total, 2)

        # entregas
        if status != "cancelado":
            volumes = 2 if (n_itens >= 2 and rng.random() < 0.15) else 1
            transp = rng.choice(list(TRANSPORTADORAS))
            saida_cd = (quando + dt.timedelta(days=rng.randint(1, 3))).date()
            for v in range(1, volumes + 1):
                tentativas = rng.choices([1, 2, 3], weights=[85, 12, 3])[0]
                dia = saida_cd
                for t in range(1, tentativas + 1):
                    dia = dia + dt.timedelta(days=rng.randint(1, 3))
                    custo = TRANSPORTADORAS[transp] + rng.randint(0, 900) / 100
                    if dia > FIM.date():  # ainda na rua
                        resultado, dia_reg = None, None
                    else:
                        resultado = "entregue" if t == tentativas else "nao_encontrado"
                        dia_reg = dia
                    if status == "em_andamento" and t == tentativas and rng.random() < 0.6:
                        resultado, dia_reg = None, None
                    if dia >= dt.date(2026, 6, 10) and rng.random() < 0.3:
                        custo = None
                    id_ent += 1
                    entregas.append([id_ent, n, v, t, "ida", transp, saida_cd, dia_reg, resultado,
                                     None if custo is None else round(custo, 2)])
                    if resultado is None:
                        break
            if status == "devolvido":
                volta = dia + dt.timedelta(days=rng.randint(5, 9))
                id_ent += 1
                entregas.append([id_ent, n, 1, 1, "devolucao", transp, volta - dt.timedelta(days=2), volta,
                                 "recebido_cd", round(TRANSPORTADORAS[transp] + rng.randint(0, 900) / 100, 2)])

        # status final: pedido com volume ainda na rua está em andamento
        if status != "cancelado":
            na_rua = any(e[1] == n and e[4] == "ida" and e[8] is None for e in entregas[-8:])
            if na_rua and status == "entregue":
                status = "em_andamento"
            elif not na_rua and status == "em_andamento":
                status = "entregue"
            pedidos[-1][4] = status

        # pagamentos
        dia_pag = quando + dt.timedelta(minutes=rng.randint(1, 90))
        if status == "cancelado":
            if rng.random() < 0.5:
                id_pag += 1
                pagamentos.append([id_pag, n, dia_pag, "cartao", total, "aprovado"])
                id_pag += 1
                pagamentos.append([id_pag, n, dia_pag + dt.timedelta(days=1), "cartao", total, "estornado"])
        else:
            r = rng.random()
            if r < 0.06:  # dividido em cartão e pix
                parte = round(total * rng.choice([0.3, 0.5, 0.6]), 2)
                id_pag += 1
                pagamentos.append([id_pag, n, dia_pag, "cartao", parte, "aprovado"])
                id_pag += 1
                pagamentos.append([id_pag, n, dia_pag + dt.timedelta(minutes=3), "pix", round(total - parte, 2), "aprovado"])
            elif r < 0.10:  # cartão recusado, depois pix
                id_pag += 1
                pagamentos.append([id_pag, n, dia_pag, "cartao", total, "recusado"])
                id_pag += 1
                pagamentos.append([id_pag, n, dia_pag + dt.timedelta(minutes=10), "pix", total, "aprovado"])
            elif status == "em_andamento" and r < 0.16:  # boleto ainda não pago
                id_pag += 1
                pagamentos.append([id_pag, n, dia_pag, "boleto", total, "pendente"])
            else:
                id_pag += 1
                pagamentos.append([id_pag, n, dia_pag, rng.choice(["cartao", "pix", "boleto"]), total, "aprovado"])
            if status == "devolvido":
                id_pag += 1
                pagamentos.append([id_pag, n, dia_pag + dt.timedelta(days=rng.randint(12, 20)), "pix", total, "estornado"])

    def escrever(nome, cab, linhas, fmt):
        with open(saida / nome, "w", newline="", encoding="utf-8") as f:
            w = csv.writer(f, lineterminator="\n")
            w.writerow(cab)
            for l in linhas:
                w.writerow(["" if x is None else fmt.get(j, str)(x) for j, x in enumerate(l)])

    data = lambda x: x.isoformat()
    hora = lambda x: x.strftime("%Y-%m-%d %H:%M:%S")
    escrever("clientes.csv", ["id_cliente", "nome", "cidade", "uf", "data_cadastro"], clientes, {4: data})
    escrever("produtos.csv", ["id_produto", "nome", "categoria", "preco_lista"], produtos, {3: dinheiro})
    escrever("pedidos.csv", ["id_pedido", "id_cliente", "data_hora_pedido", "canal", "status"], pedidos, {})
    escrever("itens_pedido.csv", ["id_pedido", "n_item", "id_produto", "quantidade", "preco_unitario", "desconto"],
             itens, {4: dinheiro, 5: dinheiro})
    escrever("pagamentos.csv", ["id_pagamento", "id_pedido", "data_hora_pagamento", "forma", "valor", "status"],
             pagamentos, {2: hora, 4: dinheiro})
    escrever("entregas.csv", ["id_entrega", "id_pedido", "volume", "tentativa", "tipo", "transportadora",
                              "data_saida", "data_tentativa", "resultado", "custo_frete"],
             entregas, {6: data, 7: data, 9: dinheiro})
    return {"clientes": len(clientes), "produtos": len(produtos), "pedidos": len(pedidos),
            "itens_pedido": len(itens), "pagamentos": len(pagamentos), "entregas": len(entregas)}


def main():
    ap = argparse.ArgumentParser(description="Gera a base da Loja Exemplo das aulas de SQL analítico.")
    ap.add_argument("--saida", default=str(pathlib.Path(__file__).resolve().parent))
    n = gerar(pathlib.Path(ap.parse_args().saida))
    print(" ".join("%s=%d" % kv for kv in n.items()))


if __name__ == "__main__":
    main()
