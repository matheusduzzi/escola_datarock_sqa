# Vendas do semestre por UF e selo: o que o Renato me mandou

O Renato, do comercial, vai apresentar as vendas do semestre na reunião de julho. O Caio já mandou uma versão do quadro, no `caio-uf-selo.sql`, e o Renato quer saber se pode usar.

## O que ele quer

- As vendas **entregues** de 01/01/2026 a 20/06/2026, o último dia da base.
- Um quadro por **UF** e por **selo**, com o número de pedidos e o valor.
- A UF e o selo de cada pedido são os do **dia em que o pedido foi feito**. Ele quer o mesmo quadro em qualquer dia em que for rodado.
- O valor de um pedido é a soma dos itens: `quantidade * preco_unitario - desconto`, com desconto vazio contando como zero.

## Os dois históricos

| Arquivo | Uma linha por | Colunas |
|---|---|---|
| `dados/historico_endereco.csv` | cliente e período em que a cidade e a UF não mudaram | id_cliente, cidade, uf, valido_de, valido_ate |
| `dados/selo_cliente.csv` | cliente e mês de selo | id_cliente, selo, valido_de, valido_ate, registrado_em |

Nos dois, o `valido_de` é o primeiro dia do período e o `valido_ate` é o dia em que o período seguinte começa. No endereço, `valido_ate` vazio quer dizer que o período continua até hoje. No selo, todo período tem fim.

## Como o selo funciona

- O programa começou em 01/02/2026. Antes disso, nenhum cliente tinha selo.
- No dia 1 de cada mês, o CRM dá a cada cliente cadastrado antes desse dia um selo pelo valor dos pedidos que ele fez no mês anterior: ouro a partir de R$ 800, prata a partir de R$ 300, bronze abaixo disso.
- O selo vale o mês inteiro, do dia 1 até o dia 1 do mês seguinte.
- `registrado_em` é o dia em que o CRM gravou a linha. A rodada de abril atrasou e foi gravada em 08/04.

O Renato quer saber o que vendeu cada selo, e não o que o sistema mostrava no dia. Para esse quadro, use o selo que valia.
