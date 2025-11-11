DROP TABLE IF EXISTS store
CREATE TABLE store(
row_id	INT PRIMARY KEY,
order_id	VARCHAR(20),
order_date	DATE,
ship_date	DATE,
ship_mode	VARCHAR(20),
customer_id	VARCHAR(20),
customer_name	VARCHAR(25),
segment VARCHAR(20),
country	VARCHAR(20),
city	VARCHAR(20),
state	VARCHAR(25),
postal_code	BIGINT,
region	VARCHAR(20),
product_id	VARCHAR(20),
category	VARCHAR(20),
sub_category	VARCHAR(20),
product_name	VARCHAR(150),
sales	FLOAT,
quantity	INT,
discount	FLOAT,
profit	FLOAT
)

-- How many rows does the dataset contain?
SELECT
	COUNT(*)
FROM store

-- What is the total sales amount?

SELECT
	ROUND(SUM(sales)::numeric,1) AS total_sales
FROM store

-- What is the total profit?

SELECT
	ROUND(SUM(profit)::numeric,1) AS total_profit
FROM store

-- What is the average discount?

SELECT
	ROUND(AVG(discount)::numeric,1) AS avg_discount
FROM store

-- How many unique segments are there, and what are they?

SELECT
	COUNT(DISTINCT segment) AS unique_segments
FROM store

-- Which are the top 5 states with the highest number of orders?

SELECT
	state,
	COUNT(order_id)
FROM store
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- How many unique customers are there?

SELECT
	COUNT(DISTINCT customer_id) AS unique_customers
FROM store

-- What is the most common shipping mode?

SELECT
	ship_mode,
	COUNT(ship_mode)
FROM store
GROUP BY 1
ORDER BY 2 DESC

-- Which product category has the highest number of sales?
SELECT *
FROM
(
SELECT
	category,
	COUNT(order_id),
	RANK() OVER(ORDER BY COUNT(order_id) DESC) AS ranking
FROM store
GROUP BY 1
)
WHERE ranking = 1

-- What is the highest profit made on a single order?
WITH table1
AS
(
SELECT
	order_id,
	MAX(profit),
	RANK() OVER(ORDER BY MAX(profit) DESC) AS ranking
FROM store
GROUP BY 1
)

SELECT *
FROM table1
WHERE ranking <= 1

-- What is the total profit per product category?

SELECT
	category,
	ROUND(SUM(profit)::numeric,1) AS total_profit
FROM store
GROUP BY 1

-- What is the average profit margin by category?

SELECT
	category,
	ROUND(AVG(profit / sales  * 100)::numeric,1) AS profit_margin
FROM store
GROUP BY 1

-- Which are the top 10 best-selling products by total sales?
SELECT *
FROM
(
SELECT
	product_id,
	product_name,
	ROUND(SUM(sales)::numeric,1),
	RANK() OVER(ORDER BY SUM(sales) DESC) AS ranking
FROM store
GROUP BY 1,2
)
WHERE ranking <= 10

-- Which are the top 5 most profitable states?
SELECT *
FROM
(
SELECT
	state,
	ROUND(SUM(profit)::numeric,1),
	RANK() OVER(ORDER BY SUM(profit) DESC) AS ranking
FROM store
GROUP BY 1
)
WHERE ranking <= 5

-- What is the number of orders per customer and the average profit per customer?

SELECT
	customer_id,
	COUNT(order_id) AS orders_per_customer,
	ROUND(AVG(profit)::numeric,1) AS avg_profit
FROM store
GROUP BY 1

-- Determină ziua săptămânii cu cele mai multe comenzi.

SELECT
	TO_CHAR(order_date, 'FMDay') AS ziua,
	COUNT(order_id) AS nr_comenzi_per_zi
FROM store
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- Calculate the average shipping time.

SELECT
    AVG(ship_date - order_date) AS avg_shipping_days
FROM store;


