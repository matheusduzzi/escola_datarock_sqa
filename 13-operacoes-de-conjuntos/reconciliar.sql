-- As contas fecham? O romaneio é o que bateu mais o que faltou.
-- O que foi bipado é o que bateu mais o que veio a mais.
WITH bipadas AS (
    SELECT produto FROM doca1 UNION ALL SELECT produto FROM doca2
), bateu AS (
    SELECT produto FROM romaneio INTERSECT ALL SELECT produto FROM bipadas
), faltou AS (
    SELECT produto FROM romaneio EXCEPT ALL SELECT produto FROM bipadas
), a_mais AS (
    SELECT produto FROM bipadas EXCEPT ALL SELECT produto FROM romaneio
)
SELECT (SELECT COUNT(*) FROM romaneio) AS romaneio,
       (SELECT COUNT(*) FROM bipadas)  AS bipadas,
       (SELECT COUNT(*) FROM bateu)    AS bateu,
       (SELECT COUNT(*) FROM faltou)   AS faltou,
       (SELECT COUNT(*) FROM a_mais)   AS a_mais,
       (SELECT COUNT(*) FROM bateu) + (SELECT COUNT(*) FROM faltou) = (SELECT COUNT(*) FROM romaneio) AS fecha_romaneio,
       (SELECT COUNT(*) FROM bateu) + (SELECT COUNT(*) FROM a_mais) = (SELECT COUNT(*) FROM bipadas)  AS fecha_bipadas;
