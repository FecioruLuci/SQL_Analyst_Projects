DROP TABLE IF EXISTS phones
CREATE TABLE phones(
brand	VARCHAR(25),
model	VARCHAR(25),
price_usd	INT,
ram_gb	INT,
storage_gb	INT,
camera_mp	INT,
battery_mah	INT,
display_size_inch	FLOAT,
charging_watt	INT,
fiveg_support	VARCHAR(10),
os	VARCHAR(25),
processor	VARCHAR(25),
rating	FLOAT,
release_month	VARCHAR(25),	
year	INT
)

SELECT *
FROM phones

-- 1. Select all columns from the table.

SELECT 
	COUNT(*)
FROM phones

-- 2.Display only the brand and model.

SELECT
	brand,
	model
FROM phones

-- 3. Show all phones with a price under 500 USD.

SELECT
	brand,
	model,
	price_usd
FROM phones
WHERE price_usd < 500

-- 4.Show all phones that support 5G.

SELECT
	brand,
	model
FROM phones
WHERE fiveg_support = 'Yes'

-- 5. Display all distinct operating systems (OS).

SELECT
	DISTINCT os
FROM phones

-- 6. Show all phones released in June.

SELECT
	brand,
	model
FROM phones
WHERE release_month = 'June'

-- 7. Display the models that have more than 8GB of RAM.

SELECT
	model
FROM phones
WHERE ram_gb > 8

-- 8. Show all models ordered by price in ascending order.

SELECT
	model,
	price_usd
FROM phones
ORDER BY 2 ASC

-- 9. Show all models ordered by rating in descending order.

SELECT
	model,
	rating
FROM phones
ORDER BY 2 DESC

-- 10. Display the total number of phones in the table.

SELECT
	COUNT(model) AS total_phones
FROM phones

-- 11. Display the average phone price for each brand.

SELECT
	brand,
	ROUND(AVG(price_usd)::numeric,1) AS avg_price
FROM phones
GROUP BY 1

-- 12. Show the phone with the largest battery capacity.

SELECT
	brand,
	model,
	battery_mah
FROM phones
ORDER BY 3 DESC
LIMIT 1

-- 13. Display the number of models available for each OS.

SELECT
	COUNT(model) AS counter,
	os
FROM phones
GROUP BY 2

-- 14. Find all models released between June and August (months 6–8).

SELECT
	model,
	release_month
FROM phones
WHERE release_month = 'June' OR release_month = 'July' OR release_month = 'August'

-- 15. Display the models that have both RAM ≥ 8GB and price < 700 USD.

SELECT
	model,
	ram_gb,
	price_usd
FROM phones
WHERE price_usd < 700 AND ram_gb >= 8

-- 16. Show the brands that have at least 110 models in the table.
SELECT *
FROM
(
SELECT
	brand,
	COUNT(model) AS counter
FROM phones
GROUP BY 1
)
WHERE counter > 110

-- 17. Calculate the average rating for phones that support 5G.

SELECT
	ROUND(AVG(rating)::numeric,2) AS avg_rating
FROM phones
WHERE fiveg_support = 'Yes'

-- 18. Display all models that do NOT support 5G.

SELECT
	model,
	fiveg_support
FROM phones
WHERE fiveg_support != 'Yes'

-- 19. Find the model with the best “price/performance” ratio defined as price_usd / ram_gb.

SELECT
	model,
	price_usd,
	ram_gb,
	price_usd / ram_gb AS price_perf
FROM phones
ORDER BY 4 ASC
LIMIT 1

-- 20. Display the number of models released each month, ordered from highest to lowest.

SELECT
	release_month,
	COUNT(model)
FROM phones
GROUP BY 1
ORDER BY 2 DESC

-- 21. Display the top 3 models with the highest rating for each brand, 
-- and if ratings are equal, sort by price in descending order.
SELECT *
FROM
(
SELECT
	brand,
	model,
	rating,
	price_usd,
	ROW_NUMBER () OVER(PARTITION BY brand ORDER BY rating DESC, price_usd DESC) AS ranking
FROM phones
)
WHERE ranking <= 3

-- 22. For each brand, calculate the price difference between each model and the previous model of the same brand 
-- (ordered alphabetically by model), and also show the brand’s average price.
WITH table1
AS
(
SELECT
	brand,
	model,
	price_usd,
	LAG(price_usd) OVER(PARTITION BY brand ORDER BY model)AS previous
FROM phones
)

SELECT 
	t1.brand,
	t1.model,
	t1.price_usd,
	t1.previous,
	price_usd - previous AS difference,
	ROUND(AVG(price_usd) OVER(PARTITION BY brand)::numeric,1)
FROM table1 as t1
WHERE previous IS NOT NULL

-- 23. For each year, determine the model with the highest price increase compared to the previous model 
-- of the same brand (using LAG()).
WITH table1
AS
(
SELECT
	brand,
	model,
	price_usd,
	year,
	LAG(price_usd) OVER(partition BY brand ORDER BY year,model) AS previous
FROM phones
ORDER BY year ASC
),
table2
AS
(
SELECT
	t1.brand,
	t1.model,
	t1.price_usd,
	t1.previous,
	t1.year,
	(price_usd - previous)AS price_increase
FROM table1 AS t1
WHERE previous IS NOT NULL
)
SELECT *
FROM
(
SELECT
		brand,
		model,
		price_usd,
		previous,
		price_increase,
		year,
		ROW_NUMBER() OVER(PARTITION BY year,brand ORDER BY price_increase DESC) AS ranking
FROM table2 as t2
)
WHERE ranking <= 1

-- 24. Compute the mean, median, and 90th percentile of price for each brand.
WITH table1
AS
(
SELECT
	brand,
	ROUND(AVG(price_usd)::numeric,1) as mean,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price_usd) as mediann,
	PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY price_usd) as percentile_90
FROM phones
GROUP BY 1
),
table2
AS
(
SELECT
	brand,
	model,
	price_usd,
	ROW_NUMBER() OVER(PARTITION BY brand ORDER BY price_usd) AS ranking
FROM phones
)

SELECT
	t1.brand,
	t2.model,
	t1.mean,
	t1.mediann,
	t1.percentile_90,
	t2.price_usd,
	t2.ranking
FROM table1 as t1
LEFT JOIN table2 as t2
ON t1.brand = t2.brand
ORDER BY t1.brand, t2.price_usd 

-- 25. Find the top 5 manufacturers with the highest average ratio of (camera_mp / display_size_inch).

SELECT
	brand,
	ROUND(AVG(camera_mp / display_size_inch)::numeric,2) AS avg_ratio
FROM phones
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- 26. Compute the correlation between battery_mah and display_size_inch for each brand.

SELECT
	brand,
	ROUND(CORR(battery_mah, display_size_inch)::numeric,3) AS correlation
FROM phones
GROUP BY 1

-- 27. Return all models released in the last 6 months relative to the most recent date 
-- in the dataset (without hardcoding any year).

SELECT
	brand,
	model,
	release_month
FROM phones
WHERE (release_month = 'June' OR
	release_month = 'July' OR
	release_month = 'September' OR
	release_month = 'October' OR
	release_month = 'November' OR
	release_month = 'August') AND
	year = 2025

-- 28. Find all models with a large battery but weak charging, defined as:
-- battery_mah > percentile_cont(0.75) and
-- charging_watt < percentile_cont(0.25)
-- (across the entire dataset)
with table1
AS
(
SELECT
	PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY battery_mah) AS batt_perc,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY charging_watt) AS char_perc
FROM phones
)

SELECT
	brand,
	model,
	battery_mah,
	charging_watt,
	t1. batt_perc,
	t1.char_perc
FROM phones
JOIN table1 as t1
ON TRUE
WHERE battery_mah > t1.batt_perc
	AND
	charging_watt < t1.char_perc

-- 29. Create a CTE that assigns a performance category to each processor 
-- (e.g., Snapdragon 8 → high, Snapdragon 4 → low), then compute the average price per category.
-- everything + snapdragon 7+ gen 2 medium, snapdragon 6 gen 1 low and snapdragon 8 gen 3 high
WITH table1
AS
(
SELECT
	brand,
	model,
	price_usd,
	processor,
	CASE
	WHEN processor = 'Snapdragon 6 Gen 1' THEN 'Low'
	WHEN processor = 'Snapdragon 8 Gen 3' THEN 'High'
	ELSE 'Medium'
	END AS category
FROM phones
)

SELECT
	category,
	ROUND(AVG(price_usd)::numeric,2)
FROM table1 as t1
GROUP BY 1

-- 30. Display all models that have a higher price than the average price of all models with the same processor.
with table1
AS
(
SELECT
	processor,
	AVG(price_usd) AS avg_price
FROM phones
GROUP BY 1
)

SELECT
	p.model,
	p.price_usd,
	t1.avg_price,
	p.processor
FROM phones as p
JOIN table1 as t1
ON p.processor = t1.processor
WHERE p.price_usd > t1.avg_price