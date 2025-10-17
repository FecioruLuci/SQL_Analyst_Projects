# Monday Coffee Expansion SQL Project

![Company Logo](https://github.com/FecioruLuci/SQL_Analyst_Projects/blob/main/fifthproject/coffeefirstpage.jpg)

## Objective
The goal of this project is to analyze the sales data of Monday Coffee, a company that has been selling its products online since January 2023, and to recommend the top three major cities in India for opening new coffee shop locations based on consumer demand and sales performance.

## Key Questions
1. **Coffee Consumers Count**  
   How many people in each city are estimated to consume coffee, given that 25% of the population does?

   1. **-- Q1 -- Retrieve the names of all tracks that have more than 1 billion streams.**
```sql
SELECT
	track,
	stream
FROM spotifytable
WHERE stream > 1000000000;
```

3. **Total Revenue from Coffee Sales**  
   What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?

4. **Sales Count for Each Product**  
   How many units of each coffee product have been sold?

5. **Average Sales Amount per City**  
   What is the average sales amount per customer in each city?

6. **Q6 -- What are the top 3 selling products in each city based on sales volume?**  
```sql
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
```
7. **-- Q7 -- How many unique customers are there in each city who have purchased coffee products?**

```sql
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
```

8. **Q8 -- Find each city and their average sale per customer and avg rent per customer**

```sql
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
```

9. **-- Q9 -- Sales growth rate: Calculate the percentage growth (or decline) by each city in sales over different time periods (monthly).**

```sql
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
WHERE growth IS NOT NULL;
```

10. **-- Q10 -- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer**

 ```sql
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
-- if u want a business delhi for sure cause of coffee consumer profits if u wanna live there as a customer jaipur for sure
-- delhi is for rich people with the most rent and they make a lot from coffee with almost the same customers as other 2 
-- jaipur is for poor people with the lowest rent 
-- pune is between those 2
```   
## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## Author - Birsan Lucian

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. Thank you for watching.

- **LinkedIn**: [[Connect with me professionally](https://www.linkedin.com/in/najirr](https://github.com/FecioruLuci))
- **Email**: [[Connect with me professionally](birsan.lucian04@gmail.com))

