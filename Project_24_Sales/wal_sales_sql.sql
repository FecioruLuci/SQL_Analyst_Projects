
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
-- day name
SELECT 
	date,
	to_char(date, 'DAY') AS day_name
FROM walsales;

ALTER TABLE walsales
ADD COLUMN day_name VARCHAR(15);

UPDATE walsales
SET day_name = to_char(date, 'DAY');

SELECT *
FROM walsales;

-- month name

SELECT 
	date,
	to_char(date, 'MON') AS month_name
FROm walsales;

ALTER TABLE walsales
ADD COLUMN month_name VARCHAR(15);

UPDATE walsales
SET month_name = to_char(date, 'MON');

SELECT *
FROM walsales

-- How many uniques cities does the dataset have

SELECT
	COUNT(DISTINCT(city)) AS unique_cities
FROM walsales

-- In which city is each branch?

SELECT
	DISTINCT(branch),
	city
FROM walsales

-- How many unique product lines does the data have?
WITH 
table1
AS
(
SELECT
	COUNT(DISTINCT(product_line)) AS unique_product_line
FROM walsales
),
table2
AS
(
SELECT
	DISTINCT(product_line) AS product_lines
FROM walsales
)

SELECT
	product_lines,
	unique_product_line
FROm table1,table2

-- What is the most common payment method?
SELECT
	payment,
	ROW_NUMBER() OVER(ORDER BY nr_ofpayments DESC) AS ranking
FROM
(
SELECT
	payment,
	COUNT(payment) AS nr_ofpayments
FROM walsales
GROUP BY 1
);

SELECT
	payment,
	COUNT(payment),
	ROW_NUMBER() OVER(ORDER BY COUNT(payment) DESC) AS ranking
FROm walsales
GROUP BY 1

-- What is the most selling product line?

SELECT
	product_line,
	COUNT(product_line) AS counter,
	RANK() OVER(ORDER BY COUNT(product_line) DESC)
FROM walsales
GROUP BY 1

-- What is the total Revenue by month?

SELECT
	month_name,
	ROUND(SUM(total)::numeric,2) AS total_revenue
FROm walsales
GROUP BY 1
ORDER BY 2 DESC

-- What month had the largest COGS?

SELECT
	month_name,
	ROUND(SUM(cogs)::numeric,2) AS largest_cogs
FROM walsales
GROUP BY 1
ORDER BY 2 DESC

-- What product line had the largest revenue?

SELECT
	product_line,
	ROUND(SUM(total)::numeric,1) AS largest_revenue_productline,
	RANK() OVER(ORDER BY SUM(total) DESC) AS ranking
FROM walsales
GROUP BY 1

-- What is the city with the largest revenue??

SELECT
	city,
	ROUND(SUM(total)::numeric,2) AS largest_rev_city,
	RANK() OVER(ORDER BY SUM(total) DESC) AS ranking
FROM walsales
GROUP BY 1

-- What product line had the largest VAT?

SELECT
	product_line,
	ROUND(AVG(tax_5_perc)::numeric,2) AS VAT
FROM walsales
GROUP BY 1
ORDER BY 2 DESC

-- Which branch sold more products that average sold?

SELECT
	branch,
	SUM(quantity) AS total_qty
FROM walsales
GROUP BY 1
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM walsales)

-- Fetch each product line and add a column to those product line showing "good", "bad". Good if its greater than avg sales

SELECT
	product_line,
	AVG(quantity) as avg_sales,
	CASE
	WHEN AVG(quantity) > (SELECT AVG(quantity) FROM walsales) THEN 'Good'
	ELSE 'Bad'
	END AS avg_sales_category
FROM walsales
GROUP BY 1

ALTER TABLE walsales
ADD COLUMN avg_sales_category VARCHAR(15)

UPDATE walsales w
SET avg_sales_category =(
CASE
WHEN
avg_qty > (SELECT AVG(quantity) FROm walsales) THEN 'Good'
ELSE 'Bad'
END
)
FROM(

SELECT
	product_line,
	AVG(quantity) as avg_qty
FROm walsales
GROUP BY 1
)t
WHERE w.product_line = t.product_line

SELECT *
FROm walsales

-- What is the most common product line by gender

SELECT
	product_line,
	COUNT(gender) AS ctr
FROm walsales
GROUP BY 1
ORDER BY 2 DESC

-- What is the average rating of each product line?

SELECT
	product_line,
	ROUND(AVG(rating)::numeric,1) AS avg_rating
FROM walsales
GROUP BY 1

-- Number of sales made in each time of the day per weekday

SELECT
	time_category,
	day_name,
	COUNT(*) AS counter
FROM walsales
GROUP BY 1,2
ORDER BY 2

-- Which of the customer type brings revenue?

SELECT
	customer_type,
	ROUND(SUM(total)::numeric,2) AS total_rev
FROM walsales
GROUP BY 1
ORDER BY 2 DESC

-- Which city has the largest tax percent/VAT

SELECT
	city,
	ROUND(AVG(tax_5_perc)::numeric,1) AS tax_perc
FROM walsales
GROUP BY 1
ORDER BY 2 DESC

-- Which customer type pays the most VAT?

SELECT
	customer_type,
	AVG(tax_5_perc) AS ag_VAT
FROM walsales
GROUP BY 1
ORDER BY 2 DESC

-- How many unique customer types does the data have?

SELECT
	COUNT(DISTINCT(customer_type)) AS nr_of_unique_cust
FROM walsales

-- How many unique payment types does that data have?

SELECT
	COUNT(DISTINCT(payment))
FROM walsales

-- What is the most common customer type?

SELECT
	customer_type,
	COUNT(customer_type) AS ctn
FROM walsales
GROUP BY 1
ORDER BY 2 DESC

-- Which customer type buys the most?

SELECT
	customer_type,
	SUM(quantity) AS qty_ctr
FROM walsales
GROUP BY 1
ORDER BY 2 DESC

-- What is the gender of most of the customers?

SELECT
	customer_type,
	gender,
	COUNT(*) as counter,
	ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(PARTITION BY customer_type)::numeric,2)
FROM walsales
GROUP BY 1,2

SELECT *
FROM walsales


