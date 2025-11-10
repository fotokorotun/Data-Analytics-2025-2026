SELECT c.company_name, AVG(t.amount) AS mitjana_vendes
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = FALSE
GROUP BY c.company_name
ORDER BY mitjana_vendes DESC
LIMIT 1;