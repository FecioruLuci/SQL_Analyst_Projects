CREATE DATABASE firstproject;


CREATE TABLE retailsales(
	transactions_id	INT PRIMARY KEY,
    sale_date	DATE,
    sale_time	TIME,
    customer_id	INT,
    gender	VARCHAR(15),
    age	INT,
    category VARCHAR(15),
    quantiy	INT,
    price_per_unit FLOAT,	
    cogs	FLOAT,
    total_sale	FLOAT
)

-- make sure to select the database

SELECT *
FROM retailsales
WHERE     
	sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
DELETE 
FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- how many sales we have

SELECT 
	count(total_sale)
FROM retailsales;

-- how many customers do we have

SELECT
	count(distinct(customer_id)) as customerstotal
FROM retailsales;

-- how many catogories do we have

SELECT
	count(distinct(category)) as totalcategories
FROM retailsales;

-- Q1 -- write a sql query to retreive all columns for sales made on 2022-11-05

SELECT *
FROM retailsales
WHERE sale_date = "2022-11-05";

-- Q2 -- write a sql query to retreive all transactions where the category is "clothing" and the quantity sold is more than 4 in the month of nov-2022

SELECT
	*
FROM retailsales
WHERE month(sale_date) = 11 and 
year(sale_date) = 2022 and 
category = "Clothing" and 
quantiy >= 4;

-- Q3 -- write sql query to calculate total sales for each category

SELECT
	category,
    SUM(total_sale) as totalsales
FROM retailsales
GROUP BY category;

-- Q4 -- write sql query to find the average age of customers who purchased items from the "Beauty" category

SELECT
	ROUND(AVG(age)) as age_average
FROM retailsales
WHERE category = "Beauty";

-- Q5 -- write a sql query to find all tranasactions where the total_sale is greater than 1000

SELECT *
FROM retailsales
WHERE total_sale > 1000;

-- Q6 -- write a sql query to find the total number of transactions (transaction_ID) made by each gender in each category

SELECT
	gender,
    category,
	count(transactions_id) as transactionsbygender_category
FROM retailsales
GROUP BY gender,category
ORDER BY gender;

-- Q7 -- write a sql query to calculate the average sale for each month, find out best selling month in each year
SELECT *
FROM(
SELECT
		year(sale_date),
		month(sale_date),
		AVG(total_sale) as averagesales,
		RANK() OVER(partition by year(sale_date) order by AVG(total_sale)) as ranking
	FROM retailsales
	GROUP BY month(sale_date),year(sale_date)
)t WHERE ranking = 1;

-- Q8 -- write a query to find the top 5 customers based on the highest total sales

SELECT
	customer_id,
    SUM(total_sale) as totalsales
FROM retailsales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- Q9 -- write a sql query to find the number of unique customers who purchased items from each category

SELECT
	category,
	COUNT(distinct(customer_id))
FROM retailsales
GROUP BY category;

-- Q10 -- write a sql query to create each shift and number of orders (example morning <= 12, afternoonbetween 12 and 17, evening  >17)
WITH hour_sale
AS
(
SELECT
	sale_time as saletime,
    quantiy as quantity,
    CASE
    WHEN HOUR(sale_time) <= 12 then "Morning"
	WHEN HOUR(sale_time) in (12,17) then "afternoon"
    ELSE "evening"
    END as shift
FROM retailsales
)
SELECT
	COUNT(*) number_of_orders,
	shift
FROM hour_sale
GROUP BY shift

-- end of project --

