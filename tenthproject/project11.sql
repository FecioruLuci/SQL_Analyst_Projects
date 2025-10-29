DROP TABLE IF EXISTS bmwtable
CREATE TABLE bmwtable(
Model	VARCHAR(25),
Year	INT,
Region	VARCHAR(25),
Color	VARCHAR(25),
Fuel_Type	VARCHAR(25),
Transmission	VARCHAR(25),
Engine_Size_L	FLOAT,
Mileage_KM	FLOAT,
Price_USD	FLOAT,
Sales_Volume	INT,
Sales_Classification	VARCHAR(10)
)

SELECT *
FROM bmwtable

-- What is the average price for each fuel type

SELECT
	fuel_type,
	ROUND(AVG(price_usd)::numeric,2) as average_price
FROM bmwtable
GROUP BY 1;

-- How many cars are there in each region

SELECT
	COUNT(*) as total_cars,
	region
FROM bmwtable
GROUP BY 2;

-- What are the top 3 models with the highest sales volume in each region
WITH table1
AS
(
SELECT
	model,
	region,
	sales_volume,
	ROW_NUMBER () OVER(PARTITION BY region ORDER BY sales_volume DESC) as ranking
FROM bmwtable
)

SELECT *
FROM table1
WHERE ranking <=3;

-- What is the average price for cars with automatic vs manual transmission, for cars with engine size greater than 2

SELECT
	transmission,
	ROUND(AVG(price_usd)::numeric,2) as average_price
FROM bmwtable
WHERE engine_size_l > 2
GROUP BY 1
ORDER BY 2 DESC;

-- For each sales classification and region, calculate the percentage of cars 
--that are red out of the total number of cars in that classification and region
WITH table1
AS
(
SELECT
	sales_classification,
	region,
	COUNT(*) as total_counter
FROM bmwtable
GROUP BY 1,2
),
table2
AS
(
SELECT
	sales_classification,
	region,
	COUNT(*) as red_counter
FROM bmwtable
WHERE color = 'Red'
GROUP BY 1,2
)

SELECT
	table1.sales_classification,
	table1.region,
	ROUND((red_counter::numeric / total_counter::numeric) * 100,1) as percentage_of_red_cars
FROM table1
LEFT JOIN table2
ON table1.region = table2.region
	AND
	table1.sales_classification = table2.sales_classification;

-- What is the year-over-year percentage growth of average price for each region
WITH table1
AS
(
SELECT
	year,
	region,
	ROUND(AVG(price_usd)::numeric,1) as average_price,
	ROUND(LAG(AVG(price_usd)) OVER (PARTITION BY region ORDER BY bmwtable.year ASC)::numeric,1) as last_year
FROM bmwtable
GROUP BY 1,2
)

SELECT
	year,
	region,
	average_price,
	last_year,
	(average_price - last_year) / last_year * 100 as growth
FROM table1
WHERE last_year is not NULL;

--Which are the top 3 models that have appreciated the most in value on the used market?
WITH table1
AS
(
SELECT
	year,
	model,
	ROUND(AVG(price_usd)) as average_price,
	ROUND(LAG(AVG(price_usd)) OVER(PARTITION BY model ORDER BY bmwtable.YEAR ASC)) as last_year
FROM bmwtable
GROUP BY 1,2
ORDER BY 1 ASC
)

SELECT
	year,
	model,
	average_price,
	last_year,
	(average_price - last_year) / last_year * 100 as appreciation
FROM table1
WHERE last_year IS NOT NULL
ORDER BY 1 DESC,5 DESC;

--What is the average price and sales volume for each Fuel_Type + Transmission combination?

SELECT
	ROUND(AVG(price_usd)::numeric,2) as avg_price,
	ROUND(AVG(sales_volume)::numeric,2) as avg_sales,
	fuel_type,
	transmission
FROM bmwtable
GROUP BY 3,4;

--How does average mileage vary by engine size and region?

SELECT
	engine_size_l,
	region,
	ROUND(AVG(mileage_km)::numeric) as avg_mileage
FROM bmwtable
GROUP BY 2,1
ORDER BY 2,1;

--What is the color distribution across different sales classifications?

SELECT
	color,
	COUNT(color) as color_distrib,
	sales_classification
FROM bmwtable
GROUP BY 3,1;

--For each year and region, show the top 3 colors and how their rankings changed
WITH table1
AS
(
SELECT
	year,
	region,
	color,
	COUNT(*) as counter
FROM bmwtable
GROUP BY 3,1,2
ORDER BY 1,2,3
),
ranked 
AS
(

SELECT 
	year,
	region,
	color,
	counter,
	ROW_NUMBER() OVER(PARTITION BY year,region ORDER BY counter DESC) as ranking
FROM table1
),
rank_changed
AS
(
SELECT 
	r1.year,
	r1.region,
	r1.color,
	r1.counter,
	r1.ranking,
	r1.ranking - r2.ranking as ranking_change
FROM ranked as r1
LEFT JOIN ranked as r2
ON r1.color = r2.color
	AND
	r1.region = r2.region
	AND 
	r1.year = r2.year + 1
)

SELECT
	year,
	region,
	color,
	counter,
	ranking,
	ranking_change
FROM rank_changed
WHERE ranking_change is not NULL;

--What is the price difference compared to regional average for each vehicle and each region?
WITH table1
AS
(
SELECT
	region,
	ROUND(AVG(price_usd)::numeric) as avg_price
FROM bmwtable
GROUP BY 1
),

table2
AS
(
SELECT
	model,
	region,
	ROUND(AVG(price_usd)::numeric) as price_model
FROM bmwtable
GROUP BY 1,2
)

SELECT
	t2.model,
	t2.region,
	t2.price_model,
	t1.avg_price,
	(t2.price_model - t1.avg_price) as price_diff
FROM table1 as t1
LEFT JOIN table2 as t2
ON t1.region = t2.region
ORDER BY 2