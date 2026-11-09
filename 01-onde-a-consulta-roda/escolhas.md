# Onde cada pedido roda

Nome:

Salve uma cópia deste arquivo com o seu nome e preencha. Os pedidos A, B e C estão no exercício da aula «Onde a consulta roda».

Ambientes: banco do sistema da loja (transacional, MySQL 8.4), banco analítico da empresa (BigQuery) ou DuckDB no seu computador.

## Parte 1. Os três pedidos

### Pedido A. O status no app

- Onde roda:
- Motivo 1:
- Motivo 2:
- O que não serve, e por quê:

### Pedido B. A recompra por canal

- Onde roda:
- Motivo 1:
- Motivo 2:
- O que não serve, e por quê:

### Pedido C. As regras de rateio da Marta

- Onde roda:
- Motivo 1:
- Motivo 2:
- O que não serve, e por quê:

## Parte 2. Levar para outro banco

As duas consultas rodam no DuckDB do kit. Rode cada uma de dentro desta pasta para ver o resultado de partida:

```bash
python3 consultar.py --dados ../dados --arquivo consulta-1.sql
python3 consultar.py --dados ../dados --arquivo consulta-2.sql
```

### Consulta 1, para o banco analítico (BigQuery)

```sql
SELECT date_trunc('month', data_hora_pedido) AS mes,
       COUNT(*) AS pedidos,
       SUM(CASE WHEN canal = 'app' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS pct_app
FROM pedidos
GROUP BY mes
ORDER BY mes;
```

- O que muda no BigQuery:
- A consulta reescrita:
- O que aconteceria sem mudar:

### Consulta 2, para a tela do app (MySQL 8.4)

```sql
SELECT p.id_pedido,
       "status",
       c.cidade || '/' || c.uf AS destino
FROM pedidos p
JOIN clientes c ON c.id_cliente = p.id_cliente
WHERE p.id_pedido = 3;
```

- O que muda no MySQL:
- A consulta reescrita:
- O que aconteceria sem mudar:
