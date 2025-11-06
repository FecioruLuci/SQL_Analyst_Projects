DROP TABLE IF EXISTS fruits
CREATE TABLE fruits (
IDul SERIAL PRIMARY KEY,
category VARCHAR(25),	
name	VARCHAR(100),
price	FLOAT,
discountPercent	INT,	
availableQuantity	INT,
discountedSellingPrice	FLOAT,
weightInGms	INT,
outOfStock	VARCHAR(25),
quantity	INT
)

SELECT *
FROM fruits

-- data exploration

SELECT
	COUNT(*)
FROM fruits

SELECT	
	*
FROM fruits
WHERE name IS NULL
OR
category is NULL
OR
mrp is NULL
OR 
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL
OR 
outofstock IS NULL
OR
quantity IS NULL

SELECT
	DISTINCT category
FROM fruits

SELECT
	outofstock,
	COUNT(idul) as counter
FROM fruits
GROUP BY 1

SELECT
	name,
	COUNT(name)
FROM fruits
GROUP BY 

SELECT 
	*
FROM fruits
WHERE price = 0
OR
discountedsellingprice = 0

DELETE FROM fruits
WHERE price = 0

-- Find the top 10 best-value products based on the discount percentage
with table1
AS
(
SELECT
	category,
	name,
	discountpercent,
	price,
	ROW_NUMBER () OVER(ORDER BY discountpercent DESC) AS ranking
FROM fruits
)

SELECT 
	*
FROM table1
WHERE ranking <= 10

-- what are the products with the highest price but out of stock

SELECT DISTINCT
	name,
	price
FROM fruits
--WHERE outofstock = 'True'
ORDER BY price DESC

-- calculate the estimated revenue for each category

SELECT
	category,
	SUM(price * availablequantity) AS total_revenue
FROM fruits
GROUP BY 1
ORDER BY total_revenue DESC

-- find all the products where the price is greater than 500 rupees and discount is less than 10%

SELECT
	category,
	name,
	price,
	discountpercent
FROM fruits
WHERE price > 500 AND discountpercent < 10

-- identify the top 5 categories offering the highest average discount percentage
with table1
AS
(
SELECT
	category,
	ROUND(AVG(discountpercent),2) as avg_discount
FROM fruits
GROUP BY 1
)

SELECT 
	*
FROM table1
ORDER BY avg_discount DESC
LIMIT 5

-- find the price per gram for products above 100g and sort by best value

SELECT
	DISTINCT name,
	price,
	weightingms,
	ROUND((price / weightingms)::numeric,2) as price_per_gms
FROM fruits
WHERE weightingms > 100
ORDER BY price_per_gms ASC

-- group the products into categories like low, medium and bulk
-- i'll go for < 100 low, 100 < and > 600 medium and 600 < bulk
SELECT
	name,
	weightingms,
	CASE
	WHEN weightingms < 100 THEN 'LOW'
	WHEN weightingms BETWEEN 100 AND 600 THEN 'MEDIUM'
	ELSE 'BULK'
	END AS segmentation
FROM fruits

-- what is the total inventory weight per category

SELECT
	category,
	SUM(weightingms * availablequantity) AS total_weight_per_cgy
FROM fruits
GROUP BY 1
ORDER BY total_weight_per_cgy DESC

