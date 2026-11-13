-- Tarefa 4: esta é a consulta que o Léo usou no relatório de março.
-- Rode como está, faça as suas checagens e depois corrija aqui mesmo.
-- python3 consultar.py --arquivo respostas/tarefa-4.sql

SELECT c.cidade, COUNT(*) AS clientes, SUM(p.valor) AS faturamento
FROM pedidos p
JOIN clientes c ON c.id_cliente = p.id_cliente
WHERE p.status = 'entregue'
GROUP BY c.cidade
ORDER BY faturamento DESC;
