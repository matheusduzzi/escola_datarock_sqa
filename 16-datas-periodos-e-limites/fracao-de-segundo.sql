-- Fechar o mês em 23:59:59 funciona enquanto a hora não tem fração de segundo.
SELECT momento,
       momento BETWEEN TIMESTAMP '2026-04-01' AND TIMESTAMP '2026-04-30 23:59:59' AS entra_ate_23_59_59,
       momento >= TIMESTAMP '2026-04-01' AND momento < TIMESTAMP '2026-05-01' AS entra_meio_aberto
FROM (VALUES (TIMESTAMP '2026-04-30 23:59:59'),
             (TIMESTAMP '2026-04-30 23:59:59.400'),
             (TIMESTAMP '2026-05-01 00:00:00')) AS t(momento);
