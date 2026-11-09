# O pedido da Sofia: guardar as trocas

A Sofia, do atendimento, anota as trocas numa planilha. Ela quer que elas fiquem no banco da loja, junto com os pedidos, para a Marta, da logística, e o financeiro poderem consultar. Ela me mandou as regras como ela fala e as últimas oito solicitações.

## As regras, nas palavras da Sofia

1. "A gente troca item de pedido entregue, até 30 dias depois que o pedido chegou. Se o pedido veio em dois volumes, conta do dia em que chegou o último." (O prazo é da loja do curso, não o do Código de Defesa do Consumidor.)
2. "Troca é sempre de um item do pedido. Se o cliente quer trocar dois itens, são duas trocas."
3. "Pode trocar só parte da quantidade: comprou duas panelas, troca uma. Mais do que comprou, não."
4. "Só tem três motivos: defeito, chegou quebrado e diferente do anúncio. Desistiu da compra é devolução, que é outro processo."
5. "O cliente pode escolher outro produto no lugar. Na maioria das vezes é o mesmo."
6. "O mesmo item pode ter mais de uma troca, mas só uma aberta por vez. Aberta é solicitada ou aprovada."
7. "A troca começa solicitada. Depois fica aprovada ou recusada. A aprovada vira concluída quando o cliente recebe o produto novo, e aí eu anoto a data."
8. "Coleta e envio do produto novo a Marta organiza. Diferença de preço o financeiro resolve. Isso fica para depois."

## As oito solicitações

O item é o número do item dentro do pedido, a coluna `n_item` da tabela `itens_pedido`. O produto novo é o `id_produto` da tabela `produtos`.

| # | Pedido | Item | Quantidade | Motivo | Produto novo | Solicitada em | Situação |
|---|---|---|---|---|---|---|---|
| 1 | 103 | 1 | 1 | defeito | 3 | 05/02/2026 | aprovada |
| 2 | 115 | 4 | 1 | chegou quebrado | 8 | 02/02/2026 | concluída em 10/02/2026 |
| 3 | 101 | 2 | 1 | diferente do anúncio | 27 | 13/03/2026 | solicitada |
| 4 | 107 | 3 | 1 | defeito | 26 | 03/02/2026 | solicitada |
| 5 | 112 | 1 | 2 | diferente do anúncio | 7 | 06/02/2026 | solicitada |
| 6 | 103 | 1 | 1 | defeito | 3 | 09/02/2026 | solicitada |
| 7 | 115 | 4 | 1 | chegou quebrado | 8 | 12/02/2026 | solicitada |
| 8 | 136 | 1 | 1 | desistiu da compra | 2 | 04/02/2026 | solicitada |

A Sofia anotou do jeito que o cliente falou. Nem toda linha segue as regras.
