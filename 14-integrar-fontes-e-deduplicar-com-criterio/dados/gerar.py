"""Gera os três cadastros da aula: site.csv, loja.csv e evento.csv.

Só usa a biblioteca padrão e sempre produz os mesmos arquivos. Rode nesta pasta:

    python3 gerar.py

O id_cliente do site é o mesmo da base compartilhada do curso (../../dados/clientes.csv),
com a mesma cidade. Os telefones e e-mails são inventados.
"""
import csv
import pathlib
import unicodedata

AQUI = pathlib.Path(__file__).resolve().parent
DDD = {'Campinas': '19', 'Sorocaba': '15', 'Jundiaí': '11', 'Piracicaba': '19', 'Ribeirão Preto': '16',
       'Santos': '13', 'Limeira': '19', 'Bauru': '14', 'Curitiba': '41', 'Valinhos': '19',
       'Hortolândia': '19', 'Sumaré': '19'}

# id_cliente, nome, cidade, atualizado_em (data em que o cliente mexeu no cadastro do site)
SITE = [
    (3, 'Ana Paula Souza', 'Campinas', '2025-08-15'), (6, 'Bruno Teixeira', 'Campinas', '2025-04-14'),
    (9, 'Carla Mendes', 'Campinas', '2025-08-19'), (12, 'Daniel Rocha', 'Campinas', '2025-11-01'),
    (15, 'Elaine Castro', 'Campinas', '2025-02-17'), (18, 'Fábio Nogueira', 'Campinas', '2025-08-01'),
    (21, 'Gisele Pires', 'Campinas', '2025-04-08'), (24, 'Henrique Lopes', 'Campinas', '2025-05-23'),
    (27, 'Isabela Martins', 'Campinas', '2025-05-06'), (30, 'João Vitor Ramos', 'Campinas', '2025-06-07'),
    (33, 'Karina Duarte', 'Sorocaba', '2025-09-14'), (36, 'Leandro Moura', 'Sorocaba', '2025-08-15'),
    (39, 'Lúcia Prado', 'Sorocaba', '2025-01-27'), (42, 'Márcio Antunes', 'Sorocaba', '2025-12-05'),
    (45, 'Natália Freitas', 'Sorocaba', '2025-05-14'), (48, 'Otávio Brandão', 'Sorocaba', '2025-12-03'),
    (51, 'Patrícia Lemos', 'Jundiaí', '2025-02-13'), (54, 'Renato Cunha', 'Jundiaí', '2025-12-09'),
    (57, 'Sandra Vieira', 'Jundiaí', '2026-06-10'), (60, 'Tiago Barros', 'Jundiaí', '2025-08-20'),
    (63, 'Vanessa Coelho', 'Jundiaí', '2025-11-06'), (66, 'Wagner Siqueira', 'Piracicaba', '2026-06-18'),
    (69, 'Yara Fontes', 'Piracicaba', '2025-11-07'), (72, 'Alexandre Pinto', 'Piracicaba', '2025-09-25'),
    (75, 'Beatriz Moraes', 'Piracicaba', '2025-09-14'), (78, 'Cláudio Rezende', 'Ribeirão Preto', '2025-03-01'),
    (81, 'Débora Sales', 'Ribeirão Preto', '2025-09-09'), (84, 'Eduardo Paiva', 'Ribeirão Preto', '2025-09-27'),
    (87, 'Fernanda Araújo', 'Ribeirão Preto', '2025-07-18'), (90, 'Gustavo Leal', 'Santos', '2025-03-05'),
    (93, 'Heloísa Tavares', 'Santos', '2025-03-20'), (96, 'Igor Monteiro', 'Santos', '2025-08-26'),
    (99, 'Juliana Batista', 'Santos', '2025-01-12'), (102, 'Kleber Assis', 'Limeira', '2025-05-15'),
    (105, 'Larissa Quintana', 'Limeira', '2025-02-15'), (108, 'Mateus Farias', 'Limeira', '2025-10-10'),
    (111, 'Nádia Correia', 'Bauru', '2026-06-14'), (114, 'Paulo Sérgio Dias', 'Curitiba', '2025-08-06'),
    (117, 'Renata Gomes', 'Curitiba', '2025-09-05'), (120, 'Sílvio Amaral', 'Curitiba', '2025-11-12'),
]
DOMINIO_SITE = {9: 'correio.example', 33: 'correio.example', 72: 'correio.example', 105: 'correio.example'}


def sem_acento(t):
    return ''.join(c for c in unicodedata.normalize('NFD', t) if unicodedata.category(c) != 'Mn')


def numero_cliente(i):
    return '9' + f'{8000 + i * 13:04d}' + f'{(i * 7919) % 10000:04d}'


def numero_novo(k):
    return '9' + f'{2000 + k * 37:04d}' + f'{(k * 4241) % 10000:04d}'


def formatar(ddd, n, jeito):
    return {'site': f'({ddd}) {n[:5]}-{n[5:]}', 'espaco': f'{ddd} {n[:5]}-{n[5:]}', 'colado': f'{ddd}{n}',
            'mais55': f'+55 {ddd} {n[:5]}-{n[5:]}', 'parenteses': f'({ddd}){n[:5]}-{n[5:]}'}[jeito]


def email_de(nome, dominio='email.example'):
    partes = sem_acento(nome).lower().split()
    return f'{partes[0]}.{partes[-1]}@{dominio}'


CLIENTE = {i: (nome, cidade, data) for i, nome, cidade, data in SITE}


def tel_cliente(i, jeito):
    return formatar(DDD[CLIENTE[i][1]], numero_cliente(i), jeito)


def email_cliente(i):
    return email_de(CLIENTE[i][0], DOMINIO_SITE.get(i, 'email.example'))


def tel_novo(k, cidade, jeito):
    return formatar(DDD[cidade], numero_novo(k), jeito)


# id_loja, nome, email, telefone, cidade, atualizado_em (data do cadastro no caixa)
LOJA = [
    ('L01', 'ANA P SOUZA', ' Ana.Souza@email.example', tel_cliente(3, 'espaco'), 'Campinas', '2026-02-10'),
    ('L02', 'BRUNO TEIXEIRA', 'BRUNO.TEIXEIRA@EMAIL.EXAMPLE', tel_novo(8, 'Campinas', 'espaco'), 'Campinas', '2026-03-05'),
    ('L03', 'DANIEL ROCHA', 'daniel.rocha@email.example', '', 'Campinas', '2026-01-20'),
    ('L04', 'FABIO NOGUEIRA', 'fabio.nogueira@email.example', tel_cliente(18, 'mais55'), 'Campinas', '2026-04-02'),
    ('L05', 'ISABELA MARTINS', 'isabela.martins@email.example', tel_novo(9, 'Campinas', 'colado'), 'Campinas', '2025-03-01'),
    ('L06', 'KARINA DUARTE', 'Karina.Duarte@Correio.example', tel_cliente(33, 'espaco'), 'Campinas', '2026-05-12'),
    ('L07', 'NATALIA FREITAS', 'natalia.freitas@email.example ', tel_cliente(45, 'colado'), 'Sorocaba', '2026-02-28'),
    ('L08', 'SANDRA VIEIRA', 'SANDRA.VIEIRA@EMAIL.EXAMPLE', tel_novo(10, 'Jundiaí', 'espaco'), 'Jundiaí', '2026-06-01'),
    ('L09', 'YARA FONTES', 'yara.fontes@email.example', tel_cliente(69, 'parenteses'), '', '2026-01-15'),
    ('L10', 'KLEBER ASSIS', 'kleber.assis@email.example  ', '', 'Limeira', '2026-03-18'),
    ('L11', 'GISELE PIRES', '', tel_cliente(21, 'colado'), 'Campinas', '2026-02-14'),
    ('L12', 'LEANDRO MOURA', 'leo.moura@outro.example', tel_cliente(36, 'espaco'), 'Sorocaba', '2026-04-22'),
    ('L13', 'PATRICIA L LEMOS', '', tel_cliente(51, 'mais55'), 'Jundiaí', '2026-01-08'),
    ('L14', 'WAGNER SIQUEIRA', '', tel_cliente(66, 'espaco'), 'Piracicaba', '2026-03-30'),
    ('L15', 'ALEXANDRE PINTO', '', tel_cliente(72, 'colado'), 'Piracicaba', '2026-05-05'),
    ('L16', 'MATEUS FARIAS', '', tel_cliente(108, 'parenteses'), 'Limeira', '2026-02-02'),
    ('L17', 'ANA PAULA SOUZA', '', tel_cliente(3, 'colado'), 'Campinas', '2026-05-20'),
    ('L18', 'MARCOS PRADO', '', tel_cliente(39, 'espaco'), 'Sorocaba', '2026-03-12'),
    ('L19', 'LETICIA LOPES', 'leticia.lopes@email.example', tel_cliente(24, 'colado'), 'Campinas', '2026-04-09'),
    ('L20', 'CARLA MENDES', 'carla.m@email.example', tel_novo(11, 'Campinas', 'espaco'), 'Campinas', '2026-02-21'),
    ('L21', 'TIAGO BARROS', '', tel_novo(12, 'Campinas', 'colado'), 'Campinas', '2026-05-27'),
    ('L22', 'ROBERTO SANTANA', 'roberto.santana@email.example', tel_novo(1, 'Campinas', 'espaco'), 'Campinas', '2026-01-11'),
    ('L23', 'ROBERTO SANTANA', '', tel_novo(1, 'Campinas', 'colado'), 'Campinas', '2026-04-18'),
    ('L24', 'SIMONE FARIA', 'simone.faria@correio.example', '', 'Valinhos', '2026-02-07'),
    ('L25', 'SIMONE FARIA', 'SIMONE.FARIA@CORREIO.EXAMPLE', tel_novo(2, 'Valinhos', 'parenteses'), 'Valinhos', '2026-05-30'),
    ('L26', 'VITOR HUGO ALVES', 'vitor.alves@email.example', tel_novo(3, 'Hortolândia', 'espaco'), 'Hortolândia', '2026-01-25'),
    ('L27', 'TERESA LIMA', '', tel_novo(4, 'Campinas', 'colado'), 'Campinas', '2026-03-03'),
    ('L28', 'OSCAR NUNES', 'oscar.nunes@correio.example', tel_novo(5, 'Sumaré', 'espaco'), 'Sumaré', '2026-04-11'),
    ('L29', 'MIRELA COSTA', 'Mirela.Costa@Email.example', tel_novo(6, 'Campinas', 'espaco'), 'Campinas', '2026-02-19'),
    ('L30', 'ERICO MACHADO', '', tel_novo(7, 'Campinas', 'mais55'), 'Campinas', '2026-06-02'),
]

# Lista de presença do evento de 13/06/2026 na loja (usada no exercício).
EV = '2026-06-13'
EVENTO = [
    ('E01', 'CARLA MENDES', 'carla.mendes@correio.example', tel_cliente(9, 'espaco'), 'Campinas', EV),
    ('E02', 'BRUNO TEIXEIRA', 'bruno.teixeira@email.example', tel_novo(13, 'Campinas', 'colado'), 'Campinas', EV),
    ('E03', 'JOAO VITOR RAMOS', 'Joao.Ramos@email.example', tel_novo(14, 'Campinas', 'espaco'), 'Campinas', EV),
    ('E04', 'VANESSA COELHO', 'vanessa.coelho@email.example', '', 'Jundiaí', EV),
    ('E05', 'ELAINE CASTRO', 'ELAINE.CASTRO@EMAIL.EXAMPLE', tel_cliente(15, 'mais55'), 'Campinas', EV),
    ('E06', 'ROBERTO SANTANA', '', tel_novo(1, 'Campinas', 'parenteses'), 'Campinas', EV),
    ('E07', 'MIRELA COSTA', 'MIRELA.COSTA@EMAIL.EXAMPLE', '', 'Campinas', EV),
    ('E08', 'PEDRO ROCHA', '', tel_cliente(12, 'espaco'), 'Campinas', EV),
    ('E09', 'JULIANA BATISTA', 'ju.batista@correio.example', tel_novo(15, 'Hortolândia', 'espaco'), 'Hortolândia', EV),
    ('E10', 'RAQUEL DINIZ', 'raquel.diniz@email.example', tel_novo(16, 'Campinas', 'espaco'), 'Campinas', EV),
    ('E11', 'RAQUEL DINIZ', 'Raquel.Diniz@Email.example', '', 'Campinas', EV),
    ('E12', 'CAMILA TORRES', '', tel_novo(17, 'Sumaré', 'colado'), 'Sumaré', EV),
    ('E13', 'NELSON VAZ', 'nelson.vaz@correio.example', tel_novo(18, 'Campinas', 'espaco'), 'Campinas', EV),
    ('E14', 'ODETE PRATES', 'odete.prates@email.example', '', 'Valinhos', EV),
    ('E15', 'SR ANTONIO', '', '', 'Campinas', EV),
]


def gravar(nome, cabecalho, linhas):
    with open(AQUI / nome, 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f, lineterminator='\n')
        w.writerow(cabecalho)
        w.writerows(linhas)


def main():
    site = [(i, nome, email_cliente(i), tel_cliente(i, 'site'), cidade, data) for i, nome, cidade, data in SITE]
    cab = ['nome', 'email', 'telefone', 'cidade', 'atualizado_em']
    gravar('site.csv', ['id_cliente'] + cab, site)
    gravar('loja.csv', ['id_loja'] + cab, LOJA)
    gravar('evento.csv', ['id_evento'] + cab, EVENTO)
    print(f'site={len(site)} loja={len(LOJA)} evento={len(EVENTO)}')


if __name__ == '__main__':
    main()
