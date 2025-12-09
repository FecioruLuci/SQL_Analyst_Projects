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