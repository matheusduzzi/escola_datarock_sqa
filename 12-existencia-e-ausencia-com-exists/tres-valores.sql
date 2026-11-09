-- O que IN e NOT IN respondem quando a lista tem um valor vazio (NULL).
SELECT 7 NOT IN (3, 5)       AS not_in_sem_vazio,
       7 NOT IN (3, 5, NULL) AS not_in_com_vazio,
       7 IN (3, 7, NULL)     AS in_achou,
       7 IN (3, 5, NULL)     AS in_nao_achou,
       7 <> NULL             AS diferente_de_vazio;
