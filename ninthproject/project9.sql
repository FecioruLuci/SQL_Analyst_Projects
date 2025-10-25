DROP TABLE IF EXISTS pizzatable
CREATE TABLE pizzatable (
pizza_id INT PRIMARY KEY,	
order_id	INT,
pizza_name_id	VARCHAR(15),
quantity	INT,
order_date	DATE,
order_time	TIME,
unit_price	FLOAT,
total_price	FLOAT,
pizza_size	VARCHAR(15),
pizza_category	VARCHAR(15),
pizza_ingredients	VARCHAR(125),
pizza_name	VARCHAR(50)
);

SELECT *
FROM pizzatable;

-- Find the total revenue

SELECT
	ROUND(SUM(total_price)) as total_revenue
FROM pizzatable;

-- Average order value

SELECT
	ROUND((ROUND(SUM(total_price)) / COUNT(DISTINCT order_id))::numeric,2) as AVG_ORDER
FROM pizzatable;

-- Total pizzas sold

SELECT 
	SUM(quantity) as Pizzas_Sold
FROM pizzatable;

--Total Orders

SELECT 
	COUNT(DISTINCT order_id) as Total_Orders
FROM pizzatable;

-- Average Pizzas Per Order

SELECT
	ROUND(((SUM(quantity))::numeric / COUNT(DISTINCT order_id))::numeric,2) as AVG_Pizza_Order
FROM pizzatable;

-- Daily trend for total orders

SELECT
	COUNT(DISTINCT order_id),
	TO_CHAR(order_date, 'Day')
FROM pizzatable
GROUP BY 2;

-- Monthly trend for total orders

SELECT
	COUNT(DISTINCT order_id),
	TO_CHAR(order_date, 'Month')
FROM pizzatable
GROUP BY 2;

-- Percentage sales by pizza category
WITH table1
AS
(
SELECT
	SUM(total_price) as total_sales
FROM pizzatable
)
SELECT
	pt.pizza_category,
	ROUND((SUM(pt.total_price) * 100 / t.total_sales)::numeric,2) as Percentage
FROM pizzatable as pt
CROSS JOIN table1 as t
GROUP BY 1, t.total_sales
