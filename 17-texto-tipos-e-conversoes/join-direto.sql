-- Juntar o texto do extrato direto com o número da loja. Termina com erro, de propósito.
CREATE VIEW extrato AS
SELECT * FROM read_csv('dados/extrato_pix_marco.csv', header = true, all_varchar = true);

SELECT COUNT(*) AS linhas
FROM extrato e
JOIN pedidos p ON p.id_pedido = e.pedido;
