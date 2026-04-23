DROP TABLE IF EXISTS walsales
CREATE TABLE walsales(
invoice_id	VARCHAR(15) PRIMARY KEY,
branch	VARCHAR(15),
city	VARCHAR(15),
customer_type	VARCHAR(15),
gender	VARCHAR(15),
product_line	VARCHAR(25),
unit_price	FLOAT,
quantity	INT,
tax_5_perc	FLOAT,
total	FLOAT,
date	DATE,
time	TIME,
payment	VARCHAR(15),
cogs	FLOAT,
gross_margin_percentage	FLOAT,	
gross_income	FLOAT,
rating	FLOAT
)

SELECT
	time,
	CASE
	WHEN time > '00:00:00' AND time <= '11:59:59' THEN 'Morning'
	WHEN time > '11:59:59' AND time <= '17:59:59' THEN 'Afternoon'
	ELSE 'Evening'
	END AS time_category
	
FROM walsales;

ALTER TABLE walsales
ADD COLUMN time_category VARCHAR(20);

UPDATE walsales
SET time_category = (
	CASE
	WHEN time > '00:00:00' AND time <= '11:59:59' THEN 'Morning'
	WHEN time > '11:59:59' AND time <= '17:59:59' THEN 'Afternoon'
	ELSE 'Evening'
	END
);

SELECT *
FROM walsales