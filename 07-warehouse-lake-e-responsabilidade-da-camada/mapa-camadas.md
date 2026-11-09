# Mapa de origem, transformação e consumo

Uma folha por painel. Salve uma cópia com o seu nome antes de preencher.

As camadas são as da aula: **bruto** (o arquivo como chegou), **tratado** (tipo e chave, sem decidir regra), **consumo** (a regra da medida, escrita uma vez) e o **painel** (recorte e aparência).

## Modelo 1: vendas do Renato (preenchido na aula)

**O painel.** Vendas por mês e categoria, para o Renato, toda segunda.

| Etapa | Tabela | O que acontece aqui | Quem cuida |
|---|---|---|---|
| Origem | sistema da loja: pedidos, itens, produtos | a venda é gravada | Jorge, do sistema |
| Bruto | os três arquivos da cópia da noite | guarda como chegou, tudo texto, com o nome do arquivo | engenharia de dados |
| Tratado | `tratado_pedidos`, `tratado_itens`, `tratado_produtos` | tipo em cada coluna; desconto vazio continua vazio | quem escreve o SQL de transformação |
| Consumo | `consumo_vendas`, uma linha por item | valor da venda = quantidade × preço pago − desconto, com desconto vazio como zero | o time de dados, com o comercial dono da regra |
| Painel | painel do Renato | mês, categoria e status entregue ou em andamento | Renato |

**A prova de que bate.** As três camadas têm 1.570 linhas de item, as mesmas do arquivo. Janeiro vendido no consumo é R$ 32.815,10, o mesmo número do modelo estrela da aula 05.

**O que mudar e onde.** Mudou o jeito de contar a venda: no consumo. Mudou o mês ou o status que o Renato quer ver: no painel. Veio um arquivo errado: na origem, com o Jorge, e o bruto guarda os dois arquivos.

## Modelo 2: frete da Marta e do Rafael (o seu)

**O painel.**

### Origem

| Origem | O que manda | Como chega | Quem cuida |
|---|---|---|---|
| | | | |
| | | | |

Quem monta a cópia do e-mail para o bruto:

### Camada de cada regra

| Regra | Camada | Por quê |
|---|---|---|
| R1 | | |
| R2 | | |
| R3 | | |
| R4 | | |
| R5 | | |
| R6 | | |
| R7 | | |
| R8 | | |

### A tabela que o painel lê

**Nome.**

**Uma linha é.**

**Colunas.**

### A prova de que bate

| Checagem | Compara | Com |
|---|---|---|
| Linhas | | |
| Soma | | |

**O que mudar e onde.**
