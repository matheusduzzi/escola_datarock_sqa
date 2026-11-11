# Folha do exercício: quatro consultas novas para o histórico

Nome:

## 1. Seletividade

Cole aqui a saída de `python3 consultar.py --dados ../dados --arquivo minha-seletividade.sql`:

```text

```

## 2. Grupos

Cole aqui a saída de `python3 consultar.py --dados ../dados --arquivo meus-grupos.sql`:

```text

```

## 3. Índices que você testou

| Consulta | Índice criado | Tipo de leitura antes (`--real`) | Tipo de leitura depois (`--real`) |
|---|---|---|---|
| `cliente.sql` | | | |
| `painel-do-dia.sql` | | | |
| `canal-do-ano.sql` | | | |
| `presentes.sql` | | | |

## 4. A escolha de cada consulta

### Ficha do cliente (`cliente.sql`)

- Acesso:
- Seletividade:
- Mecanismo (DuckDB e PostgreSQL):
- O que mostra:
- Custo:
- Como testar:

### Painel do dia (`painel-do-dia.sql`)

- Acesso:
- Seletividade:
- Mecanismo (DuckDB e PostgreSQL):
- O que mostra:
- Custo:
- Como testar:

### Fechamento anual (`canal-do-ano.sql`)

- Acesso:
- Seletividade:
- Mecanismo (DuckDB e PostgreSQL):
- O que mostra:
- Custo:
- Como testar:

A partição por mês ajudaria? Quantos arquivos o filtro abre, e por que isso muda ou não a sua escolha:

### Categoria Presentes (`presentes.sql`)

- Acesso:
- Seletividade:
- Mecanismo (DuckDB e PostgreSQL):
- O que mostra:
- Custo:
- Como testar:

## 5. A resposta para o Caio

Em quais das quatro consultas o índice que ele propôs funciona, em quais não funciona, e por quê:
