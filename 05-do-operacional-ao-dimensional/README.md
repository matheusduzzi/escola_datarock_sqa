# 05. Do operacional ao dimensional

Os arquivos da aula «Do operacional ao dimensional». Rode os comandos de dentro desta pasta. As consultas usam a base da Loja Exemplo, que fica em `../dados`. O dicionário das tabelas está em [../dados/LEIA-ME.md](../dados/LEIA-ME.md).

Se o DuckDB ainda não está instalado, veja o README da raiz do kit.

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| `consultar.py` | Roda um arquivo `.sql` no DuckDB e imprime o resultado. É o mesmo programa do diagnóstico. |
| `janeiro.sql` | Os dois números de vendas de janeiro, com uma regra mudando por vez. |
| `categorias-por-pedido.sql` | Quantos pedidos têm itens de mais de uma categoria. |
| `precos.sql` | Quantos itens foram vendidos por um preço diferente do preço de tabela. |
| `estrela.sql` | Monta o modelo estrela das vendas e testa a chave de cada tabela. |
| `prova.sql` | Compara o fato com a tabela de itens e procura linhas do fato sem par nas dimensões. |
| `vendas-categoria-mes.sql` | A pergunta do Renato: vendas por mês e categoria, sem cancelados e devolvidos. |
| `frete-no-item.sql` | O frete do pedido copiado em cada item, e o que isso faz com a soma. |
| `um-pedido.sql` | O pedido 33 no fato com o frete copiado. Troque o número para ver outro. |
| `modelo-estrela.md` | A folha do exercício. Salve uma cópia com o seu nome. |
| `minha-estrela.sql` | O arquivo das suas consultas do exercício. |

Os arquivos `estrela.sql`, `prova.sql`, `vendas-categoria-mes.sql`, `frete-no-item.sql` e `um-pedido.sql` começam pela mesma parte 1, que monta as tabelas do modelo na memória. A parte 2 de cada um é a pergunta. Nada é gravado nos CSVs: cada vez que você roda, o modelo é montado de novo.

## Comandos

```bash
python3 consultar.py --dados ../dados --arquivo janeiro.sql
python3 consultar.py --dados ../dados --arquivo categorias-por-pedido.sql
python3 consultar.py --dados ../dados --arquivo precos.sql
python3 consultar.py --dados ../dados --arquivo estrela.sql
python3 consultar.py --dados ../dados --arquivo prova.sql
python3 consultar.py --dados ../dados --arquivo vendas-categoria-mes.sql
python3 consultar.py --dados ../dados --arquivo frete-no-item.sql
python3 consultar.py --dados ../dados --arquivo um-pedido.sql
python3 consultar.py --dados ../dados --arquivo minha-estrela.sql
```

O `estrela.sql` mostra `1570` linhas e `1570` chaves diferentes no `fato_vendas`. O `prova.sql` mostra `223480.76` nas duas colunas de valor.

Enquanto o `minha-estrela.sql` só tiver comentários, o programa avisa `O arquivo ainda não tem consulta` e não roda nada. Se o arquivo tiver vários comandos, o programa roda todos e mostra o resultado do último.

## Se precisar de ajuda

Deixe um comentário na aula. Conte o objetivo, o comando que você rodou, a saída que apareceu e o que já tentou, sem dados pessoais.
