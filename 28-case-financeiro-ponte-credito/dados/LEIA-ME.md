# Dados da Ponte Crédito

Quatro tabelas da Ponte Crédito, uma financeira que empresta pela internet (canal `web`) e por lojas e correspondentes (canal `parceiro`). Os contratos vão de julho de 2025 a junho de 2026.

**Data da extração: 30/06/2026, no fim do dia.** Tudo o que aconteceu até esse dia está nos arquivos. Pagamento e desembolso depois dessa data ainda não existem.

O `gerar.py` monta os quatro CSVs. Rode de novo e você recebe exatamente os mesmos arquivos (UTF-8, separados por vírgula, com cabeçalho).

## propostas.csv (2.181 linhas)

Uma linha por pedido de empréstimo.

| Coluna | Tipo | O que é |
|---|---|---|
| id_proposta | texto | Id da proposta, não se repete |
| id_cliente | texto | Id do cliente |
| canal | texto | `web` ou `parceiro` |
| data_proposta | data | Dia em que o pedido entrou |
| status | texto | `aprovada`, `recusada` ou `desistiu` |
| valor_solicitado | inteiro | Valor pedido, em reais |

Toda proposta `aprovada` virou um contrato. O canal do contrato é o canal da proposta.

## contratos.csv (1.532 linhas)

Uma linha por contrato assinado.

| Coluna | Tipo | O que é |
|---|---|---|
| id_contrato | texto | Id do contrato, não se repete |
| id_proposta | texto | Proposta que deu origem ao contrato |
| data_contrato | data | Dia da assinatura. A safra do contrato é o mês dessa data |
| valor_contratado | inteiro | Valor emprestado, em reais |
| prazo_meses | inteiro | Número de parcelas: 6, 12 ou 18 |

## desembolsos.csv (1.732 linhas)

Uma linha por liberação de dinheiro. A maior parte dos contratos é liberada de uma vez. Alguns são liberados em duas partes: 60% logo depois da assinatura e 40% de 20 a 40 dias depois. Se a segunda parte cai depois de 30/06/2026, ela ainda não está no arquivo.

| Coluna | Tipo | O que é |
|---|---|---|
| id_desembolso | texto | Id da liberação, não se repete |
| id_contrato | texto | Contrato liberado |
| data_desembolso | data | Dia em que o dinheiro saiu |
| valor | inteiro | Valor liberado, em reais |

## parcelas.csv (18.468 linhas)

Uma linha por parcela de cada contrato, inclusive as que ainda não venceram. O par `id_contrato` e `numero_parcela` não se repete.

| Coluna | Tipo | O que é |
|---|---|---|
| id_contrato | texto | Contrato |
| numero_parcela | inteiro | 1 para a primeira, 2 para a segunda, e assim por diante |
| vencimento | data | Sempre no dia 10. A parcela 1 vence no dia 10 do mês seguinte ao contrato |
| valor_parcela | decimal | Valor da parcela, em reais |
| data_pagamento | data ou vazio | Dia em que o cliente pagou. Vazio quer dizer que não pagou até 30/06/2026 |

Vazio em `data_pagamento` não é atraso por si só: a parcela pode nem ter vencido ainda. Os dias de atraso de uma parcela são a diferença entre o vencimento e o pagamento, ou entre o vencimento e 30/06/2026 se ela segue em aberto.
