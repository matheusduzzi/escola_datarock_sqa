# O pedido da Marta: três consultas para as transportadoras

A Marta, da logística, mandou esse pedido para o Caio e me copiou. São três coisas diferentes, todas sobre a tabela `entregas`.

## Como os dados chegam

- A base de análise da loja recebe uma cópia do sistema toda madrugada. A carga termina por volta das 5h. Entre uma carga e outra, nada muda na base.
- A base de hoje vai até 20/06/2026, um sábado.
- Cada linha de `entregas` é uma viagem: a ida até o cliente ou a volta de uma devolução. A semana vai de segunda a domingo, pela `data_tentativa`.
- `custo_frete` vazio quer dizer que a fatura da transportadora ainda não chegou. As faturas chegam com atraso, e um custo vazio de hoje pode estar preenchido na carga de amanhã.
- `data_tentativa` vazia quer dizer que o volume saiu e ainda não teve tentativa: está na rua.
- As transportadoras são duas: TransVale e Rota Leve.

## 1. A conciliação da semana

"Toda segunda, às 10h, eu mando para cada transportadora o frete da semana anterior: viagens, viagens ainda sem custo e o frete das viagens com custo. Na quinta a gente senta e discute esse número. Se ele mudar entre segunda e quinta, a conversa trava. Custo que chegar depois da segunda entra na conciliação da semana seguinte. Dessa vez eu quero mandar a semana de 08/06."

## 2. O portal das transportadoras

"As duas transportadoras vão ter acesso de leitura ao banco PostgreSQL 16 que a loja usa para parceiros. Lá, a tabela `entregas` tem permissão por linha: cada transportadora, com o usuário dela, só vê as próprias viagens. O Caio é o dono da tabela. Eu quero que elas vejam, no portal, o resumo por semana das viagens delas, sempre com o que a base tem."

## 3. Os volumes parados

"Eu quero a lista dos volumes que saíram há mais de 3 dias e ainda não tiveram tentativa, para ligar para a transportadora. Eu olho às 9h e às 15h. Se às 15h aparecer um volume que travou de manhã, eu ligo no mesmo dia."
