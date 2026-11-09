"""Gera os quatro CSVs da Ponte Crédito usados na aula 28 do curso de SQL analítico.

    python3 gerar.py

Rode de novo e você recebe exatamente os mesmos arquivos (o sorteio usa sempre o mesmo ponto de
partida). A Ponte Crédito, os clientes e os contratos são inventados para o estudo.
"""
import csv
import random
from datetime import date, timedelta
from pathlib import Path

AQUI = Path(__file__).resolve().parent
CORTE = date(2026, 6, 30)
MESES = [(2025, m) for m in range(7, 13)] + [(2026, m) for m in range(1, 7)]
# Contratos por mês: o web fica estável e o parceiro cresce.
WEB = [60, 62, 61, 64, 63, 66, 68, 65, 70, 72, 69, 74]
PARCEIRO = [36, 40, 44, 48, 54, 60, 66, 70, 74, 78, 82, 86]


def mais_meses(ano, mes, n):
    t = ano * 12 + (mes - 1) + n
    return t // 12, t % 12 + 1


def chance_de_parar(canal, ano, mes):
    if canal == 'web':
        return 0.05
    return 0.06 if (ano, mes) < (2025, 11) else 0.18


def gerar():
    rng = random.Random(28)
    propostas, contratos, desembolsos, parcelas = [], [], [], []
    n_cliente = 0
    for i, (ano, mes) in enumerate(MESES):
        for canal, qtd in (('web', WEB[i]), ('parceiro', PARCEIRO[i])):
            for _ in range(qtd):
                # Propostas recusadas ou desistidas antes do contrato.
                while rng.random() < 0.3:
                    n_cliente += 1
                    dia = date(ano, mes, rng.randint(1, 28))
                    propostas.append({'id_proposta': f'P{len(propostas) + 1:04}', 'id_cliente': f'C{n_cliente:04}',
                                      'canal': canal, 'data_proposta': dia.isoformat(),
                                      'status': rng.choice(['recusada', 'recusada', 'desistiu']),
                                      'valor_solicitado': rng.randint(20, 300) * 100})
                n_cliente += 1
                dia_contrato = date(ano, mes, rng.randint(1, 28))
                valor = rng.randint(20, 300 if canal == 'web' else 200) * 100
                id_prop = f'P{len(propostas) + 1:04}'
                propostas.append({'id_proposta': id_prop, 'id_cliente': f'C{n_cliente:04}', 'canal': canal,
                                  'data_proposta': (dia_contrato - timedelta(days=rng.randint(0, 6))).isoformat(),
                                  'status': 'aprovada', 'valor_solicitado': valor})
                id_ct = f'K{len(contratos) + 1:04}'
                prazo = rng.choice([6, 12, 12, 18])
                contratos.append({'id_contrato': id_ct, 'id_proposta': id_prop, 'data_contrato': dia_contrato.isoformat(),
                                  'valor_contratado': valor, 'prazo_meses': prazo})
                # Desembolso: uma parte só, ou duas (60% e 40%).
                if rng.random() < 0.15:
                    partes = [(dia_contrato + timedelta(days=1), valor * 6 // 10),
                              (dia_contrato + timedelta(days=rng.randint(20, 40)), valor - valor * 6 // 10)]
                else:
                    partes = [(dia_contrato + timedelta(days=rng.randint(0, 2)), valor)]
                for d, v in partes:
                    if d <= CORTE:
                        desembolsos.append({'id_desembolso': f'D{len(desembolsos) + 1:04}', 'id_contrato': id_ct,
                                            'data_desembolso': d.isoformat(), 'valor': v})
                # Parcelas: todas existem desde o contrato, com vencimento no dia 10 de cada mês seguinte.
                parcela_valor = round(valor * (1 + 0.025 * prazo) / prazo, 2)
                para_em = rng.choice([1, 2, 2, 3, 3, 4, 5, 6, 8]) if rng.random() < chance_de_parar(canal, ano, mes) else None
                atrasa_uma = rng.randint(1, prazo) if rng.random() < 0.05 else None
                for k in range(1, prazo + 1):
                    a, m = mais_meses(ano, mes, k)
                    venc = date(a, m, 10)
                    if para_em is not None and k >= para_em:
                        pago = None
                    elif k == atrasa_uma:
                        pago = venc + timedelta(days=rng.randint(35, 60))
                    else:
                        pago = venc + timedelta(days=rng.randint(-5, 8))
                    if pago is not None and pago > CORTE:
                        pago = None
                    parcelas.append({'id_contrato': id_ct, 'numero_parcela': k, 'vencimento': venc.isoformat(),
                                     'valor_parcela': parcela_valor,
                                     'data_pagamento': pago.isoformat() if pago else ''})
    for nome, linhas in (('propostas', propostas), ('contratos', contratos),
                         ('desembolsos', desembolsos), ('parcelas', parcelas)):
        with (AQUI / f'{nome}.csv').open('w', encoding='utf-8', newline='') as arq:
            w = csv.DictWriter(arq, fieldnames=list(linhas[0]), lineterminator='\n')
            w.writeheader()
            w.writerows(linhas)
        print(f'{nome}.csv: {len(linhas)} linhas')


if __name__ == '__main__':
    gerar()
