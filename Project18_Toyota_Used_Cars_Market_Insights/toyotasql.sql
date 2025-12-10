DROP TABLE IF EXISTS toyotaa
CREATE TABLE toyotaa (
model	VARCHAR(15),
year	INT,
price	INT,
transmission	VARCHAR(15),	
mileage	INT,
fuelType	VARCHAR(15),
tax	INT,
mpg	FLOAT,
engineSize	FLOAT
)

SELECT
	COUNT(*)
FROM toyotaa

-- 1.	What is the average price (price) of all cars in the entire dataset?

SELECT 
	ROUND(AVG(price)::numeric,2) AS avg_price
FROM toyotaa

-- 2.	Count the number of cars for each type of transmission (transmission).

SELECT
	transmission,
	COUNT(*) AS number_of_cars
FROM toyotaa
GROUP BY 1

-- 3.	Identify the top 3 most common fuel types (fuelType) and the total count of cars for each.
SELECT
	*,
	RANK() OVER(ORDER BY total_cars DESC)
FROM
(
SELECT
	fueltype,
	COUNT(*) AS total_cars
FROM toyotaa
GROUP BY 1
)
LIMIT 3

-- 4.	Find the maximum and minimum price (price) recorded in the dataset.

SELECT
	MAX(price) AS max_price,
	MIN(price) AS min_price
FROM toyotaa

-- 5.	How many cars were manufactured in each year (year)? Display the results sorted by year.

SELECT
	year,
	COUNT(*) AS total_cars_by_year
FROM toyotaa
GROUP BY 1
ORDER BY 1 ASC

-- 6.	What is the average mileage (mileage) for cars with the model 'Supra'?

SELECT
	ROUND(AVG(mileage)::numeric,2) AS avg_mileage
FROM toyotaa
WHERE model = 'Supra'

-- 7.	List all unique engine sizes (engineSize) present in the data.

SELECT
	DISTINCT engineSize
FROM toyotaa

-- 8.	Count the number of cars that have an annual tax (tax) greater than 150.

SELECT
	COUNT(*) AS cars_with_high_taxes
FROM toyotaa
WHERE tax > 150

-- 9.	What is the average mpg (miles per gallon) for cars manufactured in 2017 (year)?

SELECT
	ROUND(AVG(mpg)::numeric,2) AS average
FROM toyotaa
WHERE year = 2017

-- 10.	Find the price and model of the car with the largest engine size (engineSize).

SELECT
	model,
	price,
	enginesize
FROM toyotaa
ORDER BY 3 DESC
LIMIT 1

-- 11. Calculate the average price (price) for cars grouped by fuelType and transmission.

SELECT
	fueltype,
	transmission,
	ROUND(AVG(price)::numeric,2) AS average_price
FROM toyotaa
GROUP BY 1,2

-- 12.	Determine the percentage of the total car count that each fuelType represents.
WITH table1
AS
(
SELECT
	COUNT(*) AS total_cars
FROM toyotaa
)

SELECT
	fueltype,
	t1.total_cars,
	ROUND(COUNT(*)::numeric / t1.total_cars * 100,2) AS percentage_total
FROM toyotaa
CROSS JOIN table1 as t1
GROUP BY 1,2

--13.	Find the models (model) whose average mpg is higher than the overall average mpg of all cars.
WITH table1
AS
(
SELECT 
	ROUND(AVG(mpg)::numeric,2) as total_avg_mpg
FROM toyotaa
)

SELECT 
	model,
	t1.total_avg_mpg,
	ROUND(AVG(mpg)::numeric,2) AS avg_mpg_model
FROM toyotaa
CROSS JOIN table1 as t1
GROUP BY 1,2
HAVING AVG(mpg) > t1.total_avg_mpg

-- 14.	Identify the models (model) that have both Automatic and Manual transmission options present in the dataset.

SELECT
	 model
FROM toyotaa
WHERE transmission = 'Manual' OR
	transmission ='Automatic'
GROUP BY 1
HAVING COUNT(DISTINCT transmission) = 2

-- 15.	Assign a 'Tax Bracket' (Low, Medium, High) based on the tax column (Low less 100, 
-- Medium > 100 and less 300, High > 300). Count how many cars fall into each bracket.
SELECT
	segmentation,
	COUNT(*)
FROM
(
SELECT
	model,
	CASE
	WHEN tax <= 100 THEN 'Low Tax'
	WHEN tax > 100 AND tax <= 300 THEN 'Medium Tax'
	ELSE 'High Tax'
	END AS segmentation
FROM toyotaa
)
GROUP BY 1

-- 16.	Calculate the median mileage (mileage) for cars manufactured in the last 5 years available in the dataset.
WITH table1
AS
(
SELECT
	MAX(year) as max_year
FROM toyotaa
)



SELECT 
	ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY mileage)::numeric,2) AS median
FROM toyotaa
CROSS JOIN table1 as t1
WHERE year >= t1.max_year - 5

-- 17.	Find all cars where the price is below the average price for its specific model.
WITH table1
AS
(
SELECT
	ROUND(AVG(price)::numeric,2) AS total_avg_price
FROM toyotaa
)

SELECT
	model,
	t1.total_avg_price,
	price
FROM toyotaa
CROSS JOIN table1 as t1
WHERE price < t1.total_avg_price

-- 18.	What is the difference between the average mpg of the most expensive model and 
-- the average mpg of the cheapest model (based on average price)?
WITH table1
AS
(
SELECT
	model,
	AVG(mpg) AS avg_mpg,
	price
FROM toyotaa
GROUP BY 1,3
ORDER BY price DESC
LIMIT 1
),

table2
AS
(
SELECT
	model,
	AVG(mpg) AS avg_mpg,
	price
FROM toyotaa
GROUP BY 1,3
ORDER BY price ASC
LIMIT 1
)

SELECT *
FROM table1 AS t1
UNION ALL
SELECT *
FROM table2 AS t2
-- the cheapeast  models have a lower avg_mpg than the expensive models

-- 19.	List the model and year combinations that have a combined total mileage exceeding 500,000 miles.

SELECT
	model,
	year,
	SUM(mileage)
FROM toyotaa
GROUP BY 1,2
HAVING SUM(mileage) < 500000

-- 20.	Calculate the average engineSize for cars that cost more than the 75th percentile of the price distribution.

SELECT

	ROUND(AVG(engineSize)::numeric,2) AS avg_enginesize
FROM toyotaa
WHERE price > (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY price) from toyotaa)

-- 21.	For each model, calculate the Z-score for the price of every car. 
-- (Z-score = (price - AVG(price)) / STDDEV(price) within the model group).

SELECT
	model,
	price,
	(price - AVG(price) OVER()) / STDDEV(price) OVER() AS zcore
FROM toyotaa

-- 22.	Rank all cars based on their 'Value Index', defined as the ratio of (price / (mileage + 1)) 
-- within each model group.
SELECT
	*,
	DENSE_RANK() OVER(PARTITION BY model ORDER BY value_index DESC)
FROM
(
SELECT
	model,
	year,
	price / (mileage + 1) AS value_index
FROM toyotaa
)