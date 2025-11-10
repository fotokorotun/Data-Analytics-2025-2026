SELECT
    c.company_name AS Nombre,
    c.phone AS Telefono,
    c.country AS Pais,
    DATE(t.timestamp) AS Fecha,
    t.amount AS Amount
FROM
    company c
JOIN
    transaction t ON c.id = t.company_id
WHERE
    t.amount BETWEEN 350 AND 400
    AND DATE(t.timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
ORDER BY
    t.amount DESC;