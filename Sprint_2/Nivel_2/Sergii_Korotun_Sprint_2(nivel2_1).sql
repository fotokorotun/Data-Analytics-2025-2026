SELECT DATE(t.timestamp) AS fecha, SUM(t.amount) AS total_ventas
FROM transaction t
WHERE t.declined = FALSE
GROUP BY DATE(t.timestamp)
ORDER BY total_ventas DESC
LIMIT 5;