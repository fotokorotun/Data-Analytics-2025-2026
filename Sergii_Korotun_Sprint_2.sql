
-- NIVEL-1--

-- Ejercicio-1--
SELECT DISTINCT c.country
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = FALSE;

-- Ejercicio-2 (JOIN) --
-- Listado de los países que están generando ventas-- 
SELECT DISTINCT c.country
FROM company c
JOIN transaction t ON c.id = t.company_id
ORDER BY c.country;

-- Desde cuántos países se generan las ventas--
SELECT COUNT(DISTINCT c.country) AS number_of_sales_countries
FROM company c
JOIN transaction t ON c.id = t.company_id;

-- Identifica a la compañía con la mayor media de ventas--

SELECT c.company_name, ROUND (AVG(t.amount),2)  AS avg_sales  
FROM company c
JOIN transaction t ON c.id = t.company_id
GROUP BY c.id, c.company_name
ORDER BY avg_sales DESC
LIMIT 1;



-- Ejercicio-3 --
--  Muestra todas las transacciones realizadas por empresas de Alemania --
SELECT * FROM transaction
WHERE company_id IN (
        SELECT id FROM company 
        WHERE country = "Germany"
    );
    -- Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones --
SELECT DISTINCT company_name
FROM company
WHERE id IN (SELECT company_id FROM transaction WHERE amount > (SELECT AVG(amount) 
FROM transaction)
    );
-- Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas--
 -- Listado de empresas que carecen de transacciones --
 SELECT * FROM company
 WHERE id NOT IN (SELECT DISTINCT company_id 
        FROM transaction);
-- Eliminarán del sistema las empresas que carecen de transacciones registradas--
-- desactivamos Safe update(porque no te da eliminar) --

SET SQL_SAFE_UPDATES = 0;


DELETE FROM 
    company
WHERE 
    id NOT IN (
        SELECT DISTINCT 
            company_id 
        FROM 
            transaction
    );
  -- activamos Safe update  --
SET SQL_SAFE_UPDATES = 1;




        
-- NIVEL-2--

-- Ejercicio-1 --

SELECT DATE(timestamp) AS transaction_date,
    SUM(amount) AS total_daily_sales
FROM
    transactions.transaction  -- Especificant la base de dades (o debo que poner USE transaction)
WHERE 
    declined = 0  
GROUP BY
    transaction_date
ORDER BY
    total_daily_sales DESC
LIMIT 5;


-- Ejercicio-2--
SELECT c.country, AVG(t.amount) AS media_ventas
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = FALSE
GROUP BY c.country
ORDER BY media_ventas DESC;


-- Ejercicio-3-subconsulta--

SELECT*FROM transaction
WHERE company_id IN (
        SELECT id FROM company 
        WHERE country = (
                SELECT country FROM company
                WHERE company_name = "Non Institute")
    );

-- Ejercicio-3-Join--

SELECT t.* FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE c.country = (
    SELECT country FROM company WHERE company_name = "Non Institute"
);
-- NIVEL-3--

-- Ejercicio-1--
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
    AND DATE(t.timestamp) IN ("2015-04-29", "2018-07-20", "2024-03-13")
ORDER BY
    t.amount DESC;
    
-- Ejercicio-2---
SELECT
    c.company_name AS Nombre_Empresa,
    COUNT(t.id) AS Total_Transacciones,
    CASE
        WHEN COUNT(t.id) > 400 THEN "Más de 400 transacciones"
        ELSE "400 o menos transacciones"
    END AS Categoria_Transacciones
FROM
    company c
LEFT JOIN
    transaction t ON c.id = t.company_id
GROUP BY
    c.id, c.company_name
ORDER BY
    Total_Transacciones DESC;
