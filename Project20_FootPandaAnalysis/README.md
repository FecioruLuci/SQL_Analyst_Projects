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

## 1.Total Revenue

```sql
SELECT ROUND(SUM(total_price)) AS total_revenue FROM pizzatable;
```
## 2.Average Order Value (AOV)
```sql
SELECT ROUND((SUM(total_price) / COUNT(DISTINCT order_id))::numeric, 2) AS AVG_ORDER
FROM pizzatable;
```

## 3.Total Pizzas Sold
```sql
SELECT SUM(quantity) AS Pizzas_Sold FROM pizzatable;
```

## 4.Total Orders
```sql
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM pizzatable;
```

## 5.Average Pizzas per Order
```sql
SELECT ROUND((SUM(quantity)::numeric / COUNT(DISTINCT order_id))::numeric, 2)
AS AVG_Pizza_Order FROM pizzatable;
```

## Sales Trends

## 1.Daily Trend of Orders
```sql
SELECT COUNT(DISTINCT order_id), TO_CHAR(order_date, 'Day')
FROM pizzatable
GROUP BY 2;
```

## 2.Monthly Trend of Orders
```sql
SELECT COUNT(DISTINCT order_id), TO_CHAR(order_date, 'Month')
FROM pizzatable
GROUP BY 2;
```

## 🧀 Category and Size Performance

## 1.Percentage of Sales by Pizza Category
```sql
WITH total AS (
    SELECT SUM(total_price) AS total_sales FROM pizzatable
)
SELECT pizza_category,
       ROUND((SUM(total_price) * 100 / total.total_sales)::numeric, 2) AS Percentage
FROM pizzatable, total
GROUP BY pizza_category, total.total_sales;
```

## 2.Percentage of Sales by Pizza Size
```sql
SELECT pizza_size,
       ROUND(SUM(total_price)::numeric, 1) AS Total_Sales,
       ROUND((SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizzatable))::numeric, 2)
       AS Percentage
FROM pizzatable
GROUP BY pizza_size;
```

## 🏆 Top Performers

## Top 5 Best-Selling Pizzas by revenue, quantity, and total orders:
```sql
SELECT pizza_name,
       SUM(total_price) AS revenue,
       SUM(quantity) AS total_quantity,
       COUNT(DISTINCT order_id) AS total_orders
FROM pizzatable
GROUP BY pizza_name
ORDER BY revenue DESC
LIMIT 5;
```


## 📌 Summary

This project provides a data-driven overview of pizza sales performance, highlighting:

   -Revenue distribution across categories and sizes

   -Daily and monthly sales trends

   -Customer ordering behavior insights (AOV, average pizzas per order)

   -Top-selling products and performance breakdowns

## 🧰 Tech Stack

   SQL (PostgreSQL / MySQL compatible)
   Python (Data Transformation)

## 📫 Connect with Me

   LinkedIn: [Connect with me professionally](https://www.linkedin.com/in/birsanlucian1/)
   
   E-Mail: birsan.lucian04@gmail.com



