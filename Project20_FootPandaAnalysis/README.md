## 🍕 Pizza Sales Analysis Project

This project focuses on exploring and analyzing a pizza sales dataset to uncover insights about revenue trends, customer ordering behavior, and product performance. The analysis is performed using SQL to calculate key performance metrics and visualize patterns across categories, sizes, and time periods.

---

## 📊 Data Preparation

Created a main table named foodpanda, containing detailed data with the following fields:

customer_id, gender, age, city, signup_date, order_id, order_date, restaurant_name, dish_name, category, quantity, price, payment_method, order_frequency, last_order_date, loyalty_points, churned, rating, rating_date, delivery_status, age_int.

Ensured data integrity by defining appropriate data types.

```sql
CREATE TABLE foodpanda(
customer_id	VARCHAR(15),
gender	VARCHAR(15),
age	VARCHAR(25),
city	VARCHAR(25),
signup_date	DATE,
order_id	VARCHAR(25),
order_date	DATE,
restaurant_name	VARCHAR(25),
dish_name	VARCHAR(25),
category	VARCHAR(25),
quantity	INT,
price	FLOAT,
payment_method	VARCHAR(25),	
order_frequency	INT,
last_order_date	DATE,
loyalty_points	INT,
churned	VARCHAR(25),
rating	INT,
rating_date	DATE,
delivery_status	VARCHAR(25),
age_int INT
)
```


## 🔍 Exploratory Analysis

Using SQL queries, several key business metrics were calculated:

## 1.Total Number of unique orders

```sql
SELECT
	COUNT(DISTINCT(order_date)) AS nr_of_unique_orders
FROM foodpanda
```
## 2.Average price of a dish across all restaurants
```sql
SELECT
	ROUND(AVG(price)::numeric,2) AS avg_price
FROM foodpanda
```

## 3.City with the highest volume of orders
```sql
WITH table1
AS
(
SELECT
	city,
	COUNT(order_id) as nr_of_orders
FROM foodpanda
GROUP BY 1
)

SELECT
	city,
	RANK() OVER(ORDER BY nr_of_orders DESC)
FROM table1
```

## 4.Most preferred payment method used by customers
```sql
SELECT
	payment_method,
	COUNT(payment_method)
FROM foodpanda
GROUP BY 1
ORDER BY 2 DESC
```

## 5.Food category that contributes the most to the total revenue
```sql
SELECT
	category,
	ROUND(SUM(price)::numeric,2)
FROM foodpanda
GROUP BY 1
ORDER BY 2 DESC
```

## 6.Top 5 most popular dishes in the city with the highest sales
```sql
WITH table1
AS
(
SELECT
	city,
	dish_name,
	SUM(price) as total_sales
FROM foodpanda
GROUP BY 1,2
)

SELECT
	city,
	dish_name,
	RANK() OVER(PARTITION BY city ORDER BY total_sales DESC),
	ROUND(total_sales::numeric,1) AS total_sales_per_dishes
FROM table1
ORDER BY 1
```

## 2.Monthly order volume trend over time
```sql
with table1
AS
(
SELECT
	DATE_TRUNC('month', order_date) AS luna_an,
	COUNT(*) AS nr_comenzi
FROM foodpanda
GROUP BY 1
)

SELECT
	luna_an,
	nr_comenzi,
	LAG(nr_comenzi) OVER(ORDER BY luna_an) AS an_trecut,
	(nr_comenzi - LAG(nr_comenzi) OVER(ORDER BY luna_an)) * 100 / LAG(nr_comenzi) OVER(ORDER BY luna_an) AS procentaj
FROM table1
```

## Technical Highlights

- **CTEs (`WITH` clauses`)** for modular queries  
- **Window functions:** `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `LAG()`, `NTILE()` for ranking, segmentation, and trend analysis  
- **Aggregations:** `COUNT`, `SUM`, `AVG`, `ROUND` for business KPIs  
- **Correlation analysis:** `CORR()` to study relationships between variables  
- **Time-based analysis:** `DATE_TRUNC`, date differences for seasonality, signup-to-first-order lag, and churn calculations  
- **Advanced segmentation:** RFM scoring to classify customers as *MVPs*, *Lost-MVPs*, *Upcoming MVPs*, etc.  
- **Anomaly detection:** identifying outlier customers in terms of order frequency  

---

## Insights Generated

- **Top-performing cities, restaurants, and dishes** identified  
- **Customer loyalty and churn patterns** measured  
- **Relationship between loyalty points and ratings** evaluated  
- **Temporal trends in order volumes** analyzed  
- **High-risk customers** highlighted for potential re-engagement campaigns  
- **Restaurants eligible for partnerships** determined based on customer engagement  

---

## This SQL analysis provides a comprehensive foundation for customer analytics, restaurant performance monitoring, and business decision-making for Foodpanda.

## 🧰 Tech Stack

   SQL (PostgreSQL / MySQL compatible)
   Python (Data Transformation)

## 📫 Connect with Me

   LinkedIn: [Connect with me professionally](https://www.linkedin.com/in/birsanlucian1/)
   
   E-Mail: birsan.lucian04@gmail.com





