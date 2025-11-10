SELECT *
FROM transaction
WHERE company_id IN (
    SELECT id
    FROM company
    WHERE country = (
        SELECT country FROM company WHERE company_name = 'Non Institute'
    )
);