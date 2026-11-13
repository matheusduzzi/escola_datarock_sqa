-- O romaneio tem linha e produto; a doca tem hora e produto.
-- A operação compara pela posição da coluna, não pelo nome.
SELECT * FROM romaneio
EXCEPT ALL
SELECT * FROM doca1;
