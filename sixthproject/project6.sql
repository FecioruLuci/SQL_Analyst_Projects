SELECT *
FROM wallmart;

SELECT
	branch,
	COUNT(*)
FROM wallmart
GROUP BY branch;

DROP TABLE wallmart;

-- Q1 -- Find different payment method and number of transactions, number of quantity sold

SELECT
	DISTINCT payment_method,
	COUNT(*),
	SUM(quantity)
FROM wallmart
GROUP BY 1

-- Q2 -- Identify the highest-rated category in each branch, displaying the branch, category and avg rating
WITH table1
AS 
(
SELECT
	branch,
	category,
	AVG(rating) as average_rating,
	RANK () OVER (partition by branch ORDER BY AVG(rating) DESC) as ranking
FROM wallmart
GROUP BY 1,2
)

SELECT
	branch,
	category,
	average_rating,
	ranking
FROM table1
WHERE ranking = 1

-- Q3 -- Identify the busiest day for each branch based on number of transactions
WITH table1
AS
(
SELECT
	branch,
	TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') as formated_day,
	RANK () OVER(partition by branch ORDER BY COUNT(*) DESC) as ranking,
	COUNT(*) as number_of_trans
FROM wallmart
GROUP BY 1,2
)

SELECT
	branch,
	formated_day,
	ranking,
	number_of_trans
FROM table1
WHERE ranking = 1;

-- Q4 -- Calculate the total quantity of items sold per payment method. List payment_method and the total quantity

SELECT
	payment_method,
	SUM(quantity) as total_quantity
FROM wallmart
GROUP BY 1;

-- Q5 -- Determine the average, minimum, and maximum rating of products for each city. List the city, average_rating, min_rating
-- and max_rating

SELECT
	city,
	category,
	MAX(rating) as max,
	MIN(rating) as min,
	AVG(rating) as averagee
FROM wallmart
GROUP BY 1,2;

-- Q6 -- Calculate the total profit for each category by considering the total_profit as
-- unit_price * quantity * profit_margin. List category and total_profit, ordered from highest to lowest profit

SELECT
	category,
	ROUND(SUM(unit_price * quantity * profit_margin)::numeric,1) as total_profit
FROM wallmart
GROUP BY 1
ORDER BY 2 DESC;

-- Q7 -- Determine the most common payment method for each branch. Display branch and the preffered_payment_method
WITH table1
AS
(
SELECT
	branch,
	payment_method,
	COUNT(*),
	RANK () OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as ranking
FROM wallmart
GROUP BY 1,2
)

SELECT 
	branch,
	payment_method,
	ranking
FROM table1
WHERE ranking = 1;

-- Q9 -- Categorize sales into 3 group Morning, Afternoon, Evening
-- find out which of the shift and number of invoices
-- i go 0-12 morning 12-18 afternoon and 18-00 evening

SELECT
	branch,
	CASE
	WHEN EXTRACT(HOUR FROM time::time) BETWEEN 0 and 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM time::time) BETWEEN 12 and 18 THEN 'Afternoon'
	ELSE 'Evening'
	END AS periodd,
	COUNT(*)
FROM wallmart
GROUP BY 1,2
ORDER BY 1,3;

-- Q10 -- Identify 5 branch with highest decrease ratio in revenue compared to last year (2023 and 2022)
WITH table1
AS
(
	SELECT
		branch,
		SUM(total) as revenue
	FROM wallmart
	WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2023
	GROUP BY 1
),
table2 
AS
(
	SELECT
		branch,
		SUM(total) as revenue
	FROM wallmart
	WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2022
	GROUP BY 1
)

SELECT
	cur_year.branch,
	cur_year.revenue as cur_year,
	last_year.revenue as last_year,
	ROUND((last_year.revenue - cur_year.revenue)::numeric / last_year.revenue::numeric * 100,2) as ratioo
FROM table1 as cur_year
JOIN table2 as last_year
ON cur_year.branch = last_year.branch
WHERE last_year.revenue > cur_year.revenue
ORDER BY 4 DESC
LIMIT 5
--formula last_year - cur_year / last_year


