SELECT DISTINCT c.country
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = FALSE;