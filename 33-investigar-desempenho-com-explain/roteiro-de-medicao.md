# Roteiro de medição

Os passos que a aula «Investigar desempenho com EXPLAIN» usa para comparar o tempo de duas versões de uma consulta. Servem para qualquer comparação com o `medir.py`.

1. **Escreva a pergunta.** Uma frase, com as duas versões que você vai comparar e o que muda entre elas. Uma mudança de cada vez: o índice, a ordem da tabela, o formato dos arquivos ou as threads, nunca duas ao mesmo tempo.
2. **Monte o volume.** `python3 montar.py --milhoes N`. Anote o N e a última linha da saída, com o tamanho do banco e dos arquivos. Para comparar volumes, rode o roteiro inteiro para cada N.
3. **Prepare a máquina.** Feche os programas pesados que puder e deixe o computador na tomada. Escolha as threads e use as mesmas em todas as medidas (`--threads`, o padrão é 4).
4. **Veja o resultado primeiro.** Rode o `medir.py` nas duas versões e olhe a linha `resultado`. Se a impressão digital for diferente, as consultas retornam coisas diferentes: pare e descubra por quê. Não compare o tempo delas.
5. **Leia o plano.** `python3 plano.py --dados ../dados --arquivo <consulta>.sql --real` nas duas versões. Anote o tipo de leitura, os arquivos lidos e as linhas que saem da leitura. É o que vai explicar o tempo.
6. **Meça.** `python3 medir.py --dados ../dados --arquivo <consulta>.sql`. O padrão é 3 rodadas, 2 execuções de aquecimento e 10 medidas por rodada. Anote a mediana, a menor, a maior e a mediana de cada rodada.
7. **Meça de novo.** Rode o passo 6 outra vez, sem mudar nada. Se a ordem entre as versões trocar ou as medianas mudarem muito, a diferença ainda não está clara: aumente as rodadas (`--rodadas 5`) e meça de novo.
8. **Compare com a variação.** Uma versão só é mais rápida que a outra se a diferença entre as medianas for maior que a diferença entre as rodadas de cada uma.
9. **Escreva o alcance.** Diga a máquina, as threads e o volume em que o resultado vale. Diga o que o plano explica. Não prometa o tempo de outra máquina.
