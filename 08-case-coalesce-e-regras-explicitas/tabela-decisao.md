# Tabela de decisão

Salve uma cópia desta folha com o seu nome. O modelo 1 é o da aula, preenchido. O modelo 2 é o do exercício, em branco.

Uma tabela de decisão tem uma linha por caso. Os casos que mais importam são os de fronteira: o valor em cima do limite, o vazio e o valor que a regra não conhece. Cada linha diz a classe e o porquê, e o porquê vem de quem é dono da regra.

## Modelo 1: as faixas da campanha de julho

**A pergunta.** Quantos pedidos do semestre caíram em cada faixa de valor, para a campanha do Renato.

**Quem decide.** Renato, do comercial.

| Caso | status | valor | Faixa | Por quê |
|---|---|---|---|---|
| 1 | entregue | 198,99 | menos de 199 | um centavo abaixo do frete grátis |
| 2 | entregue | 199,00 | de 199 a 349 | 199 em ponto já ganha frete grátis |
| 3 | em_andamento | 349,00 | de 199 a 349 | "acima de 349" não inclui o 349 |
| 4 | entregue | 349,01 | mais de 349 | um centavo acima |
| 5 | cancelado | 500,00 | fora da campanha | o status vem antes do valor |
| 6 | devolvido | 150,00 | fora da campanha | o cliente devolveu |
| 7 | entregue | vazio | revisar | pedido sem item; não é pedido de R$ 0 |
| 8 | em_transito | 250,00 | revisar | status que a regra não conhece |

**O vazio e a troca.** Desconto vazio quer dizer "sem cupom" e entra como R$ 0 na conta do valor do pedido, com `COALESCE(desconto, 0)`. O valor do pedido vazio não vira zero: vai para "revisar".

**A prova.** Os oito casos rodam no `casos-fronteira.sql` e batem. Na base, as faixas somam 900 pedidos: 411, 191, 177 e 121.

## Modelo 2: a situação de cada entrega

**A pergunta.** A situação e a fatura de cada linha de `entregas`, no dia 20/06/2026, para o painel da Marta.

**Quem decide.** Marta, da logística.

| Caso | tipo | resultado | data_saida | custo_frete | Situação | Fatura | Por quê |
|---|---|---|---|---|---|---|---|
| 1 | | | | | | | |
| 2 | | | | | | | |
| 3 | | | | | | | |
| 4 | | | | | | | |
| 5 | | | | | | | |
| 6 | | | | | | | |
| 7 | | | | | | | |
| 8 | | | | | | | |

**O vazio e a troca.** Para cada coluna que pode vir vazia, o que o vazio quer dizer e se ele vira outro valor:

**A resposta à Marta sobre o zero no custo:**

**A prova.** Os casos que rodam no `situacao-entrega.sql` e a contagem da base:
