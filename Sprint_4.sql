CREATE DATABASE IF NOT EXISTS sprint_4;
USE sprint_4;


CREATE TABLE IF NOT EXISTS transaction (

id VARCHAR (255) ,
card_id VARCHAR (20) NULL,
business_id VARCHAR (255) NULL,
timestamp TIMESTAMP NULL,
amount DECIMAL (10,2) NULL,
declined BOOLEAN NULL,
user_id VARCHAR (20) NULL,
lat FLOAT NULL,
longitude FLOAT NULL

);
LOAD DATA LOCAL
INFILE "/Users/ssk/Desktop/IT_ACADEMY/SQL/Sprint_4/transactions.csv"
INTO TABLE transaction
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
IGNORE 1 ROWS;





SET GLOBAL local_infile = 1;


-- SHOW  variables like "local_infile";
-- SHOW  variables like "secure_file_priv";