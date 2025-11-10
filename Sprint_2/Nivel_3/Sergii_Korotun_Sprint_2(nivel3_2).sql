SELECT
    c.company_name AS Nombre_Empresa,
    COUNT(t.id) AS Total_Transacciones,
    CASE
        WHEN COUNT(t.id) > 400 THEN 'Más de 400 transacciones'
        ELSE '400 o menos transacciones'
    END AS Categoria_Transacciones
FROM
    company c
LEFT JOIN
    transaction t ON c.id = t.company_id
GROUP BY
    c.id, c.company_name
ORDER BY
    Total_Transacciones DESC;