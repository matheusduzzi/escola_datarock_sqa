-- A mesma conta em três jeitos de escrever: o que o DuckDB do kit retorna.
-- Rode dentro da pasta da aula:  python3 consultar.py --dados ../dados --arquivo dialetos.sql
SELECT
    COUNT(*)                                            AS pedidos,
    COUNT(*) FILTER (WHERE status = 'cancelado')        AS cancelados,
    COUNT(*) FILTER (WHERE status = 'cancelado') * 100 / COUNT(*)  AS pct_barra,
    COUNT(*) FILTER (WHERE status = 'cancelado') * 100 // COUNT(*) AS pct_barra_dupla,
    ROUND(100.0 * COUNT(*) FILTER (WHERE status = 'cancelado') / COUNT(*), 1) AS pct_arredondado
FROM pedidos;
