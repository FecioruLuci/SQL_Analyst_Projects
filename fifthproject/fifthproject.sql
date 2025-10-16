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
ON f.city_name = s.city_name
	
	
