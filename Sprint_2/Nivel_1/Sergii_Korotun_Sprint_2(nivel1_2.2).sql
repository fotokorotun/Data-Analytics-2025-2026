SELECT COUNT(DISTINCT c.country) AS total_paisos
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = FALSE;