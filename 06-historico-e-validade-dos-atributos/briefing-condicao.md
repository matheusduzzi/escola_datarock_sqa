# Condição comercial: o que o Renato me mandou

O Renato, do comercial, quer um relatório de desconto por condição comercial. Antes, ele quer saber se o histórico do sistema está certo. Ele me mandou como a loja trabalha e as decisões do semestre.

## Como a loja trabalha

- Todo cliente tem uma condição comercial em cada dia, desde o dia do cadastro.
- São três condições: **varejo**, sem desconto; **clube**, com 5% de desconto em todo pedido; **revenda**, com 10%, para quem compra para revender.
- Todo cliente começa no varejo.
- Quem decide a condição e o dia em que ela começa é o comercial. O sistema só fica sabendo quando alguém lança a decisão. Às vezes o lançamento atrasa, e às vezes uma decisão é lançada antes de começar a valer.
- Uma promoção pode ter fim marcado. Quando ela acaba, o cliente volta para o varejo.

## As decisões do semestre

| Cliente | O que o comercial decidiu | Lançado no sistema em |
|---|---|---|
| 30 | Clube de presente por três meses: de 01/02/2026 a 30/04/2026. O dia 30/04 ainda tem desconto. Depois, varejo. | 28/01/2026 |
| 90 | Entrou no clube em 15/01/2026. Pediu para sair: o último dia com desconto é 19/04/2026, e a partir de 20/04 é varejo. | entrada em 15/01/2026, saída em 20/04/2026 |
| 17 | Entrou no clube a partir de 01/03/2026. | 26/02/2026 |
| 24 | Revenda a partir de 01/03/2026, aprovada por mim nesse dia. | 12/03/2026 |
| 43 | Revenda a partir de 01/07/2026. | 15/06/2026 |

Os outros 115 clientes estão no varejo desde o cadastro.

## O arquivo do sistema

O histórico que o sistema gravou está em `dados/condicao_comercial.csv`, com uma linha por cliente e período:

| Coluna | O que guarda |
|---|---|
| `id_cliente` | o cliente |
| `condicao` | varejo, clube ou revenda |
| `desconto_pct` | o desconto da condição, em % |
| `valido_de` | o primeiro dia do período |
| `valido_ate` | o dia em que o período seguinte começa; vazio quando não tem fim marcado |
| `registrado_em` | o dia em que a decisão foi lançada no sistema |

Hoje, para o caso, é 20/06/2026.

## O que o Renato quer saber

1. Qual condição valia nos pedidos 625 (cliente 30, 30/04/2026), 336 (cliente 24, 06/03/2026) e 570 (cliente 90, 19/04/2026)?
2. O pedido 336 saiu sem o desconto de revenda. Por quê?
3. Qual é a condição do cliente 43 hoje?
