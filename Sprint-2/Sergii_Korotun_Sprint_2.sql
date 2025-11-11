-- Sergii_Korotun_Sprint_2(nivel1_2.1)--
SELECT DISTINCT c.country
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = FALSE;

-- Sergii_Korotun_Sprint_2(nivel1_2.2)--
SELECT COUNT(DISTINCT c.country) AS total_paisos
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = FALSE;

-- Sergii_Korotun_Sprint_2(nivel1_2.3)--
SELECT c.company_name, AVG(t.amount) AS mitjana_vendes
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = FALSE
GROUP BY c.company_name
ORDER BY mitjana_vendes DESC
LIMIT 1;

-- Sergii_Korotun_Sprint_2(nivel2_2.1)--
SELECT c.country, AVG(t.amount) AS media_ventas
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = FALSE
GROUP BY c.country
ORDER BY media_ventas DESC;

-- Sergii_Korotun_Sprint_2(nivel2_2.2)--
SELECT c.country, AVG(t.amount) AS media_ventas
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = FALSE
GROUP BY c.country
ORDER BY media_ventas DESC;

-- Sergii_Korotun_Sprint_2(nivel2_2.3)--

SELECT c.country, AVG(t.amount) AS media_ventas
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = FALSE
GROUP BY c.country
ORDER BY media_ventas DESC;


-- Sergii_Korotun_Sprint_2(nivel2_2.3JOIN)--

SELECT t.*
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE c.country = (
    SELECT country FROM company WHERE company_name = 'Non Institute'
);
-- Sergii_Korotun_Sprint_2(nivel3_3.1)--
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
-- Sergii_Korotun_Sprint_2(nivel3_3.2)--
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
