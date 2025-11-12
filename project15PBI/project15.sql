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

-- Which year had the highest total sales?

SELECT
	EXTRACT(YEAR FROM order_date),
	ROUND(SUM(sales)::numeric,1) AS total_sales
FROM store
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- What is the distribution of orders across customer segments?

SELECT
	segment,
	category,
	COUNT(order_id)
FROM store
GROUP BY 1,2
ORDER BY 1

-- Is there a correlation between discount and profit?

SELECT
	ROUND(CORR(discount, profit)::numeric,1)
FROM store

-- Identify the products with total losses (profit < 0) and find the top 5 least profitable ones.
SELECT *
FROM
(
SELECT
	product_id,
	product_name,
	SUM(profit),
	RANK() OVER(ORDER BY SUM(profit) ASC) AS ranking
FROM store
GROUP BY 1,2
HAVING SUM(profit) < 0
)
WHERE ranking <= 5

-- Calculate monthly revenue and analyze whether sales are trending upward or downward.
WITH table1
AS
(
SELECT
	EXTRACT(MONTH FROM order_date) AS monthh,
	ROUND(SUM(sales)::numeric,1) AS total_rev
FROM store
GROUP BY 1
),
table2
AS
(
SELECT
	table1.monthh AS monthh,
	table1.total_rev AS current_month,
	LAG(table1.total_rev) OVER(ORDER BY table1.monthh ASC) AS last_month
FROM table1
)

SELECT
	monthh,
	last_month,
	current_month,
	ROUND((current_month - last_month) / last_month * 100,1) AS perc_growth,
	CASE
	WHEN (current_month - last_month) / last_month * 100 > 0 THEN 'UP'
	WHEN (current_month - last_month) / last_month * 100 < 0 THEN 'DOWN'
	ELSE 'NULL'
	END AS segmentation
FROM table2

-- Identify loyal customers — those who placed orders in at least 3 different years.
with table1
AS
(
SELECT
	customer_id,
	EXTRACT(YEAR FROM order_date) as yearr,
	COUNT(*) AS counter
FROM store
GROUP BY 1,2
ORDER BY 1
)

SELECT
	DISTINCT customer_id
FROM(
SELECT
	*,
	RANK () OVER(PARTITION BY table1.customer_id ORDER BY yearr) AS ranking
FROM table1
)
WHERE ranking >= 3

-- Analyze whether discounts negatively impact profit.

SELECT
	ROUND(CORR(discount,profit)::numeric,1)
FROM store

-- Calculate each segment’s contribution to total profit (as a percentage).
WITH table1
AS
(
SELECT
	segment,
	SUM(profit) AS total_profit
FROM store
GROUP BY 1
)

SELECT
	table1.segment,
	total_profit,
	ROUND((total_profit / (SELECT SUM(profit) FROM store))::numeric * 100,1) As percentage
FROM table1

-- Find the average shipping time per region and correlate it 
-- with satisfaction (assume satisfaction decreases as delivery time increases).
with table1
AS
(
SELECT
	region,
	ROUND(AVG(ship_date - order_date),1),
	ROUND(1 / AVG(ship_date - order_date)::numeric,3) AS satisfaction
FROM store
GROUP BY 1
)

SELECT
	CORR(ship_date - order_date, t1.satisfaction)
FROM store as s
JOIN table1 as t1
ON s.region = t1.region

-- Detect products with high sales but low profit margins.
SELECT *
FROM
(
SELECT
	product_id,
	product_name,
	COUNT(product_id),
	ROUND(SUM(sales)::numeric,1) as total_sales_per_product,
	SUM(profit) / SUM(sales) AS profit_margin
FROM store
GROUP BY 1,2
HAVING COUNT(product_id) >= 5
)

WHERE total_sales_per_product > 
(SELECT AVG(total_sales_per_product) FROM 
(SELECT SUM(sales) AS total_sales_per_product FROM store GROUP BY product_id))
ORDER BY profit_margin ASC

-- Estimate the total profit lost due to discounts (compare actual profit vs. profit without discounts).

SELECT
    ROUND(SUM((profit / (1 - discount)) - profit)::numeric, 2) AS total_profit_lost
FROM store
WHERE discount > 0

-- Create a category × region matrix showing total profit and highlight underperforming areas.
with table1
AS
(
SELECT
	region,
	category,
	ROUND(SUM(profit)::numeric,1) AS total_profit
FROM store
GROUP BY 1,2
ORDER BY 1
)

SELECT
	table1.region,
	table1.category,
	table1.total_profit,
	ROUND(AVG(table1.total_profit) OVER(),1),
	CASE
	WHEN table1.total_profit > AVG(table1.total_profit) OVER() THEN 'Normal'
	ELSE 'Underperforming'
	END AS segmentation
FROM table1