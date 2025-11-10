SELECT t.*
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE c.country = (
    SELECT country FROM company WHERE company_name = 'Non Institute'
);