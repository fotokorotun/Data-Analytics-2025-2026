SELECT c.country, AVG(t.amount) AS media_ventas
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = FALSE
GROUP BY c.country
ORDER BY media_ventas DESC;