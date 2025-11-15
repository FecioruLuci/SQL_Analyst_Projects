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

