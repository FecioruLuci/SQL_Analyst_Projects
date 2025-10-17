# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `myproject1.sql`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT *
FROM retailsales
WHERE     
	sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE 
FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **-- Q1 -- write a sql query to retreive all columns for sales made on 2022-11-05**:
```sql
SELECT *
FROM retailsales
WHERE sale_date = "2022-11-05";
```

2. *-- Q2 -- write a sql query to retreive all transactions where the category is "clothing" and the quantity sold is more than 4 in the month of nov-2022**:
```sql
SELECT
	*
FROM retailsales
WHERE month(sale_date) = 11 and 
year(sale_date) = 2022 and 
category = "Clothing" and 
quantiy >= 4;

```

3. **-- Q3 -- write sql query to calculate total sales for each category**:
```sql
SELECT
	category,
    SUM(total_sale) as totalsales
FROM retailsales
GROUP BY category;
```

4. **-- Q4 -- write sql query to find the average age of customers who purchased items from the "Beauty" category**:
```sql
SELECT
	ROUND(AVG(age)) as age_average
FROM retailsales
WHERE category = "Beauty";
```

5. **-- Q5 -- write a sql query to find all tranasactions where the total_sale is greater than 1000**:
```sql
SELECT *
FROM retailsales
WHERE total_sale > 1000;
```

6. **-- Q6 -- write a sql query to find the total number of transactions (transaction_ID) made by each gender in each category**:
```sql
SELECT
	gender,
    category,
	count(transactions_id) as transactionsbygender_category
FROM retailsales
GROUP BY gender,category
ORDER BY gender;
```

7. **-- Q7 -- write a sql query to calculate the average sale for each month, find out best selling month in each year**:
```sql
SELECT *
FROM(
SELECT
		year(sale_date),
		month(sale_date),
		AVG(total_sale) as averagesales,
		RANK() OVER(partition by year(sale_date) order by AVG(total_sale)) as ranking
	FROM retailsales
	GROUP BY month(sale_date),year(sale_date)
)t WHERE ranking = 1;
```

8. **-- Q8 -- write a query to find the top 5 customers based on the highest total sales**:
```sql
SELECT
	customer_id,
    SUM(total_sale) as totalsales
FROM retailsales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;
```

9. **-- Q9 -- write a sql query to find the number of unique customers who purchased items from each category
**:
```sql
SELECT
	category,
	COUNT(distinct(customer_id))
FROM retailsales
GROUP BY category;
```

10. **-- Q10 -- write a sql query to create each shift and number of orders (example morning <= 12, afternoonbetween 12 and 17, evening  >17)**:
```sql
WITH hour_sale
AS
(
SELECT
	sale_time as saletime,
    quantiy as quantity,
    CASE
    WHEN HOUR(sale_time) <= 12 then "Morning"
	WHEN HOUR(sale_time) in (12,17) then "afternoon"
    ELSE "evening"
    END as shift
FROM retailsales
)
SELECT
	COUNT(*) number_of_orders,
	shift
FROM hour_sale
GROUP BY shift

-- end of project --
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## Author - Birsan Lucian

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. Thank you for watching.

- **LinkedIn**: [[Connect with me professionally](https://www.linkedin.com/in/najirr](https://github.com/FecioruLuci))
- **E-Mail**: birsan.lucian04@gmail.com


Thank you for your support, and I look forward to connecting with you!


