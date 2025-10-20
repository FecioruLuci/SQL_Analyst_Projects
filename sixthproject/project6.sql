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
WHERE ranking = 1