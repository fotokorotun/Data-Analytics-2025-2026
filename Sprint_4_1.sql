CREATE DATABASE IF NOT EXISTS sprint_4_1; -- creamos base de tatos
USE sprint_4_1;

-- creamos tablas --

CREATE TABLE IF NOT EXISTS transaction (

id VARCHAR (255) PRIMARY KEY ,
card_id VARCHAR (20) ,
business_id VARCHAR (255) ,
timestamp TIMESTAMP ,
amount DECIMAL (10,2) ,
declined BOOLEAN ,
product_ids VARCHAR (20) ,
user_id VARCHAR (255) ,
lat FLOAT ,
longitude FLOAT );



CREATE TABLE IF NOT EXISTS users (
    id VARCHAR (255)  PRIMARY KEY ,
    name VARCHAR(50) ,
    surname VARCHAR(50) ,
    phone VARCHAR(25),
    email VARCHAR(100) ,
   birth_day VARCHAR (20),
    country VARCHAR(50),
    city VARCHAR(50),
    postal_code VARCHAR(20),
    address VARCHAR(150)
);

CREATE TABLE IF NOT EXISTS credit_cards (
    id VARCHAR (255)  PRIMARY KEY ,
    user_id VARCHAR(255) ,
    iban VARCHAR(255) ,
    pan VARCHAR(255),
    pin VARCHAR(255) ,
   cvv VARCHAR (255),
    track1 VARCHAR(255),
    track2 VARCHAR(255),
    expiring_date VARCHAR(255)
);
CREATE TABLE IF NOT EXISTS companies (
    company_id VARCHAR (255)  PRIMARY KEY ,
    company_name VARCHAR(255) ,
    phone VARCHAR(255) ,
    email VARCHAR(255),
    country VARCHAR(255) ,
   website VARCHAR (255)
   );
CREATE TABLE IF NOT EXISTS products (
    id VARCHAR (255)  PRIMARY KEY ,
    product_name VARCHAR(255) ,
    price VARCHAR(255) ,
    colour VARCHAR(255),
    weight VARCHAR(255) ,
    warehouse_id VARCHAR (255)
   );
-- pasamos datos a nuestras tablas creadas
LOAD DATA  LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv'
INTO TABLE transactions
FIELDS terminated by ';'
enclosed by '"'
ignore 1 rows
;
   -- pasamos datos a nuestras tablas creadas
LOAD DATA  LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/american_users.csv'
INTO TABLE users
FIELDS terminated by ','
enclosed by '"'
ignore 1 rows
;
-- pasamos datos a nuestras tablas creadas
LOAD DATA  LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/european_users.csv'
INTO TABLE users
FIELDS terminated by ','
enclosed by '"'
ignore 1 rows
;
-- pasamos datos a nuestras tablas creadas
LOAD DATA  LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv'
INTO TABLE credit_cards
FIELDS terminated by ','
enclosed by '"'
ignore 1 rows
;
-- pasamos datos a nuestras tablas creadas
LOAD DATA  LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv'
INTO TABLE companies
FIELDS terminated by ','
enclosed by '"'
ignore 1 rows
;

LOAD DATA  LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS terminated by ','
enclosed by '"'
ignore 1 rows
;

-- creamos relaciones (FK) --

ALTER TABLE transactions
ADD CONSTRAINT fk_user_id
FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE transactions
ADD CONSTRAINT fk_card_id
FOREIGN KEY (card_id) REFERENCES credit_cards(id);

ALTER TABLE transactions
ADD constraint fk_business_id
foreign key (business_id) references companies(company_id);

 -- ALTER table transactions
  -- add constraint fk_product_ids
  -- foreign key (product_ids) references products(id);

-- doble conection por mi culpa, y deberia que borrar una de ellas.
ALTER TABLE transactions
DROP FOREIGN KEY fk_card_id;

-- NIVEL-1-1-

SELECT u.id, u.name, u.surname
FROM users u
WHERE u.id IN (
    SELECT t.user_id
    FROM transactions t
    GROUP BY t.user_id
    HAVING COUNT(t.id) > 80
)
limit 0,100;

-- NIVEL-1-2--  
 
SELECT cc.iban,
       AVG(t.amount) AS media_amount
FROM transactions t
JOIN credit_cards cc ON t.card_id = cc.id
JOIN companies c ON t.business_id = c.company_id
WHERE c.company_name = 'Donec Ltd'
GROUP BY cc.iban;

-- NIVEL-2-- (creamos una tabla que se debuelba valor si la tarjeta esta activa o no )
create table if not exists status_credit_cards (
credit_card_id varchar(255)primary key,
status_card enum ('active','inactive'),
FOREIGN KEY (credit_card_id) REFERENCES credit_cards(id)
);
-- anadimos datos variables 
INSERT INTO status_credit_cards (credit_card_id, status_card)
-- peticion--
SELECT card_id,
       CASE 
           WHEN SUM(declined) = 3 THEN 'inactive'
           ELSE 'active'
       END AS status
FROM (
    SELECT 
        t.card_id,
        t.declined,
        ROW_NUMBER() OVER (PARTITION BY t.card_id ORDER BY t.timestamp DESC) AS rn
    FROM transactions t
) AS sub
WHERE rn <= 3
GROUP BY card_id;
select count(*) AS card_activas
from status_credit_cards
where status_card = 'active';

-- NIVEL-3--



-- Creamos una tabla temporal le llamamos "trans_prod_temp" que tenga la columna "products_ids_json" que tendrá los valores en el formato JSON
-- para qual podamos extraer los valores de "product_ids" con JSON_TABLE()

CREATE TEMPORARY TABLE IF NOT EXISTS trans_prod_temp AS
SELECT id, product_ids, CONCAT('[',REPLACE( product_ids," ",""),']') AS products_ids_json
FROM transactions;




 select*from   trans_prod_temp;

-- Creamos la tabla nueva "transaction_products" con las columnas "transaction_id" y la "product_id"
CREATE TABLE IF NOT EXISTS transaction_products AS
SELECT id AS transaction_id, product_id from
trans_prod_temp,
JSON_TABLE (
products_ids_json,
'$[*]' COLUMNS(
product_id INT PATH '$'
    )) AS t;
    
-- Conectamos con  PRIMARY KEY  de dos columnas la "transaction_id" y la "product_id".
ALTER TABLE transaction_products
ADD PRIMARY KEY (transaction_id, product_id);

-- conectamos la columna "transaction_id" de la tabla "transaction_products" con  "id" de la tabla "transaction".
ALTER TABLE transaction_products
ADD CONSTRAINT fk_transaction_products_transaction_id
FOREIGN KEY(transaction_id)
REFERENCES transactions(id);

-- conectamos la columna "product_id" de la tabla "transaction_products" con  "id" de la tabla "products".
ALTER TABLE transaction_products
ADD CONSTRAINT fk_transaction_products_product_id
FOREIGN KEY(product_id)
REFERENCES products(id);

SHOW CREATE TABLE products;


-- modificamos product_id_por_INT

ALTER TABLE transaction_products
MODIFY product_id INT NOT NULL;

-- modificamos id_por_INT
ALTER TABLE products
MODIFY id INT NOT NULL;

-- revisamos FOREIGN KEYS creados.
SELECT
    table_name,
    column_name,
    constraint_name,
    referenced_table_name,
    referenced_column_name
FROM
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE
referenced_table_schema = 'transactions_sp4'  AND table_name = 'transaction_products';

-- Ejercicio_1_
-- Necesitamos conocer el número de veces que se ha vendido cada producto.
SELECT tp.product_id, p.product_name, count(*) AS num_veces_vendido
FROM transaction_products tp
JOIN products p
ON tp.product_id = p.id
JOIN transactions t
ON t.id = tp.transaction_id
WHERE t.declined = 0
GROUP By tp.product_id, p.product_name
ORDER BY num_veces_vendido DESC;

   select*from transaction_products;   -- revisamos si todo bien
 -- select*from transactions;
  select*from products;
 
 













-- SET GLOBAL local_infile = 1; para dar acceso para cargar los archivos
-- SHOW VARIABLES LIKE 'secure_file_priv'; --path desde donde se puede cargar las archivos csv
 -- SHOW GLOBAL VARIABLES LIKE 'local_infile'; -- vemos si tenemos permiso cargar los archivos locales (si pone "ON" si se puede)