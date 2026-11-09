# 04. Normalização e anomalias

Os arquivos da aula «Normalização e anomalias». Rode os comandos de dentro desta pasta.

As duas planilhas da aula ficam na pasta `dados/` daqui, e o `consultar.py` carrega essa pasta sozinho. Algumas consultas da aula comparam a planilha com a base da Loja Exemplo, que fica em `../dados`; essas leem o CSV da base direto, com `read_csv_auto('../dados/...')`. O dicionário da base está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## As planilhas

`dados/vendas_larga.csv` é a planilha do Renato, do comercial, que a aula usa. Uma linha por item vendido, com o pedido, o cliente e o produto escritos em cada linha:

| Coluna | O que guarda |
|---|---|
| `id_pedido`, `n_item` | o pedido e o número do item dentro dele |
| `data_pedido`, `canal`, `status` | o dia do pedido, onde foi feito e como está |
| `id_cliente`, `nome_cliente`, `cidade`, `uf` | o cliente do pedido |
| `id_produto`, `produto`, `categoria`, `preco_lista` | o produto do item e o preço de tabela |
| `quantidade`, `preco_unitario`, `desconto` | o que foi vendido no item e o preço que o cliente pagou; desconto vazio é item sem cupom |

`dados/entregas_larga.csv` é a planilha da Marta, da logística, que o exercício usa. Uma linha por tentativa de entrega de um volume, ou pela volta de uma devolução:

| Coluna | O que guarda |
|---|---|
| `id_entrega` | o número que o sistema dá para cada linha |
| `id_pedido`, `tipo`, `volume`, `tentativa` | o pedido, o sentido (ida ou devolucao), o volume e a tentativa |
| `id_cliente`, `cidade`, `uf` | o cliente do pedido |
| `transportadora`, `tarifa_base` | quem levou e a tarifa por viagem do contrato dessa transportadora |
| `data_saida` | o dia em que o volume saiu |
| `data_tentativa`, `resultado`, `custo_frete` | quando chegou, o que aconteceu e o frete faturado; vazio enquanto o volume está na rua ou a fatura não chegou |

Não edite os CSVs à mão para fazer o exercício.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa do diagnóstico. |
| `contas.sql` | Soma os clientes de cada cidade, os pedidos de cada status e os produtos de cada categoria, ao lado do total da planilha. |
| `copias.sql` | Em quantas linhas a cidade, a categoria e o status estão escritos, e quantos donos cada um tem. |
| `chave.sql` | Mostra que o par pedido + item não repete na planilha. |
| `dependencias.sql` | Testa sete regras de dependência: quantos donos têm mais de um valor. |
| `quebras.sql` | Mostra os donos que quebraram uma regra, com os valores e as linhas de cada um. |
| `sem-pedido.sql` | Os clientes do cadastro da base que não aparecem na planilha. |
| `apagar-janeiro.sql` | Quem sumiria da planilha se as linhas de janeiro fossem apagadas. Não apaga nada. |
| `remontar.sql` | Monta a planilha a partir das tabelas da base e compara coluna por coluna. |
| `copias-transportadora.sql` | Quantas vezes a transportadora de um volume aparece escrita em `entregas`, na base. |
| `vigia-transportadora.sql` | Os volumes da base em que as linhas discordam sobre a transportadora. |
| `um-pedido.sql` | As linhas de um pedido na planilha. Vem com o pedido 404; troque o número para ver outro. |
| `devolucao-404.sql` | As linhas do pedido 404 na tabela de entregas da base. |
| `precos.sql` | Compara o preço de lista com o preço que o cliente pagou. |
| `diagnostico-entregas.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minhas-consultas.sql` | Um arquivo em branco para as suas consultas do exercício. |

## Comandos

```bash
python3 consultar.py --arquivo contas.sql
python3 consultar.py --arquivo copias.sql
python3 consultar.py --arquivo chave.sql
python3 consultar.py --arquivo dependencias.sql
python3 consultar.py --arquivo quebras.sql
python3 consultar.py --arquivo sem-pedido.sql
python3 consultar.py --arquivo apagar-janeiro.sql
python3 consultar.py --arquivo remontar.sql
python3 consultar.py --arquivo copias-transportadora.sql
python3 consultar.py --arquivo vigia-transportadora.sql
python3 consultar.py --arquivo um-pedido.sql
python3 consultar.py --arquivo devolucao-404.sql
python3 consultar.py --arquivo precos.sql
python3 consultar.py --arquivo minhas-consultas.sql
```

O `contas.sql` mostra `113` contra `112` na linha dos clientes. O `remontar.sql` mostra `1570` linhas e `3`, `5` e `2` nas colunas de diferença. O `vigia-transportadora.sql` termina com `(0 linhas)`: nenhum volume com duas transportadoras na base.

Se aparecer `No files found that match the pattern "../dados/...`, você rodou fora da pasta da aula ou a pasta `dados/` da base não está ao lado dela. Volte para esta pasta e rode de novo.

Enquanto o `minhas-consultas.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Deixe uma consulta por vez no arquivo: se houver duas, o programa mostra só o resultado da última.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
