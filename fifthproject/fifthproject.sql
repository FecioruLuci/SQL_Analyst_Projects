CREATE DATABASE coffee;
CREATE TABLE city
(
	city_id	INT PRIMARY KEY,
	city_name VARCHAR(15),	
	population	BIGINT,
	estimated_rent	FLOAT,
	city_rank INT
);

CREATE TABLE customers
(
	customer_id INT PRIMARY KEY,	
	customer_name VARCHAR(25),	
	city_id INT,
	CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES city(city_id)
);


CREATE TABLE products
(
	product_id	INT PRIMARY KEY,
	product_name VARCHAR(35),	
	Price float
);


CREATE TABLE sales
(
	sale_id	INT PRIMARY KEY,
	sale_date	date,
	product_id	INT,
	customer_id	INT,
	total FLOAT,
	rating INT,
	CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES products(product_id),
	CONSTRAINT fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
);

-- Q6 -- What are the top 3 selling products in each city based on sales volume?
WITH ranked as
(
SELECT 
	cit.city_name,
	p.product_name,
	COUNT(s.sale_id) as total,
	DENSE_RANK () OVER (partition by city_name order by COUNT(s.sale_id) DESC) as rankingul
FROM sales as s
JOIN products as p
ON s.product_id = p.product_id
JOIn customers as c
ON c.customer_id = s.customer_id
JOIN city as cit
ON cit.city_id = c.city_id
GROUP BY 1,2
ORDER BY 1,3 DESC
)

SELECT
	city_name,
	product_name,
	total,
	rankingul
FROM ranked 
WHERE rankingul <= 3;

-- Q7 -- How many unique customers are there in each city who have purchased coffee products?
-- unique customers per city
-- coffee products purchased

SELECT 
	c.city_id,
	cit.city_name,
	COUNT(DISTINCT c.customer_id) as uniquecust
FROM city as cit
JOIN customers as c
ON cit.city_id = c.city_id
JOIN sales as s
ON s.customer_id = c.customer_id
JOIn products as p
ON p.product_id = s.product_id
WHERE p.product_name ILIKE '%coffee%'
GROUP BY c.city_id, cit.city_name
ORDER BY uniquecust DESC;

-- Q8 -- Find each city and their average sale per customer and avg rent per customer
-- average sale per customer for each city
WITH firsttable
AS
(
	SELECT
		cit.city_name,
		COUNT(DISTINCT s.customer_id) as uniquee,
		ROUND(SUM(s.total)::numeric/COUNT(DISTINCT s.customer_id)::numeric,1) as averagee
	FROM city as cit
	JOIN customers as c
	ON cit.city_id = c.city_id
	JOIN sales as s
	ON s.customer_id = c.customer_id
	GROUP BY 1
),

secondtable AS
(
	SELECT
		cit.city_name,
		cit.estimated_rent,
		COUNT(DISTINCT s.customer_id) as count_cust,
		ROUND(cit.estimated_rent::numeric / COUNT(DISTINCT s.customer_id)::numeric,1) as avg_rent
	FROM city as cit
	JOIN customers as c
	ON cit.city_id = c.city_id
	JOIN sales as s
	ON s.customer_id = c.customer_id
	GROUP BY 1,2
);

SELECT
	f.city_name,
	f.uniquee,
	f.averagee,
	s.avg_rent
FROM firsttable as f
JOIN secondtable as s
ON f.city_name = s.city_name;

-- Q9 -- Sales growth rate: Calculate the percentage growth (or decline) by each city in sales over different time periods (monthly).
WITH firsttable
AS
(
	SELECT
		EXTRACT(MONTH FROM s.sale_date) as monthul,
		EXTRACT(YEAR FROM s.sale_date) as yearr,
		cit.city_name,
		SUM(total) as total_sales
	FROM sales as s
	JOIN customers as c
	ON s.customer_id = c.customer_id
	JOIN city as cit
	ON cit.city_id = c.city_id
	GROUP BY 3,1,2
	ORDER BY 3,2,1
),

secondtable AS
(
	SELECT 
		monthul,
		yearr,
		city_name,
		total_sales,
		LAG(total_sales, 1) OVER(PARTITION BY city_name ORDER BY yearr,monthul) as nextmonthsales,
		ROUND
		((total_sales - LAG(total_sales, 1) OVER(PARTITION BY city_name ORDER BY yearr,monthul))::numeric / LAG(total_sales, 1) OVER(PARTITION BY city_name ORDER BY yearr,monthul)::numeric * 100,1) as growth
		
	FROM firsttable
)

SELECT
	monthul,
	yearr,
	city_name,
	nextmonthsales,
	growth
FROM secondtable
WHERE growth IS NOT NULL

-- Q10 -- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer
WITH firsttable
AS
(
	SELECT
		cit.city_name,
		COUNT(DISTINCT s.customer_id) as uniquee,
		ROUND(SUM(s.total)::numeric/COUNT(DISTINCT s.customer_id)::numeric,1) as averagee,
		SUM(total) as total_sales
	FROM city as cit
	JOIN customers as c
	ON cit.city_id = c.city_id
	JOIN sales as s
	ON s.customer_id = c.customer_id
	GROUP BY 1
),

secondtable AS
(
	SELECT
		cit.city_name,
		cit.estimated_rent,
		COUNT(DISTINCT s.customer_id) as count_cust,
		ROUND(cit.estimated_rent::numeric / COUNT(DISTINCT s.customer_id)::numeric,1) as avg_rent
	FROM city as cit
	JOIN customers as c
	ON cit.city_id = c.city_id
	JOIN sales as s
	ON s.customer_id = c.customer_id
	GROUP BY 1,2
),

thirdtable as
(
	SELECT
		city_name,
		ROUND
		((population * 0.25) / 1000000,3) as est_coffee_consumer_mills
	FROM city
)

SELECT
	f.city_name as city_name,
	total_sales,
	estimated_rent as total_rent,
	count_cust as total_customers,
	est_coffee_consumer_mills,
	ROUND
	((estimated_rent / count_cust)::numeric,1) as rent_per_customer
FROM firsttable as f
JOIN secondtable as s
ON f.city_name = s.city_name
JOIN thirdtable as t
ON t.city_name = f.city_name
ORDER BY total_sales DESC

-- pune total sales(mills) 1.2 total_customer 52 and rent/customer 294
-- jaipur total sales(mills) 0.8 total_customer 69 and rent/customer 156
-- delhi total sales(mills) 0.75 total_customer 68 and rent/customer 330

-- jaipur has bigger sales with same customers and 2 times less rent so jaipur > delhi
-- pune has 1.2 total sales with a bit less customers and almost double rent per customer
-- if u want a business pune for sure if u wanna live there as acustomer jaipur for sure
