
DROP TABLE IF EXISTS foodpanda
CREATE TABLE foodpanda(
customer_id	VARCHAR(15),
gender	VARCHAR(15),
age	VARCHAR(25),
city	VARCHAR(25),
signup_date	DATE,
order_id	VARCHAR(25),
order_date	DATE,
restaurant_name	VARCHAR(25),
dish_name	VARCHAR(25),
category	VARCHAR(25),
quantity	INT,
price	FLOAT,
payment_method	VARCHAR(25),	
order_frequency	INT,
last_order_date	DATE,
loyalty_points	INT,
churned	VARCHAR(25),
rating	INT,
rating_date	DATE,
delivery_status	VARCHAR(25)
)

SELECT *
FROM foodpanda

--	1  What is the total number of unique orders in the dataset?

SELECT
	COUNT(DISTINCT(order_date)) AS nr_of_unique_orders
FROM foodpanda

-- 2  How many unique customers are currently in our database?

SELECT
	COUNT(DISTINCT(customer_id)) AS nr_of_unique_customers
FROM foodpanda

-- 3  What is the average price of a dish across all restaurants?

SELECT
	ROUND(AVG(price)::numeric,2) AS avg_price
FROM foodpanda

-- 4  Which city has the highest volume of orders?
WITH table1
AS
(
SELECT
	city,
	COUNT(order_id) as nr_of_orders
FROM foodpanda
GROUP BY 1
)

SELECT
	city,
	RANK() OVER(ORDER BY nr_of_orders DESC)
FROM table1

-- 5  What is the most preferred payment method used by customers?

SELECT
	payment_method,
	COUNT(payment_method)
FROM foodpanda
GROUP BY 1
ORDER BY 2 DESC

-- 6  How many distinct restaurants are active on the platform?

SELECT
	COUNT(DISTINCT(restaurant_name))
FROM foodpanda

-- 7  What is the average loyalty points balance per customer?

WITH table1
AS
(
SELECT
	DISTINCT customer_id AS customer,
	loyalty_points
FROM foodpanda
)
SELECT
	customer,
	ROUND(AVG(loyalty_points)::numeric,2)
FROM table1
GROUP BY 1

-- 8  How many orders have a delivery_status of "Cancelled" or "Failed"?






