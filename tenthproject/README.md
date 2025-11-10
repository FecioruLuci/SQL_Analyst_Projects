## 🚗 BMW Sales & Market Analysis Project

This project focuses on exploring and analyzing a BMW vehicle dataset to uncover insights into pricing trends, market performance, and vehicle characteristics across different regions, years, and categories.

The analysis was performed using SQL, and complementary visual dashboards were built in Power BI to visualize key findings.

---

## 📊 Data Preparation

1.Created a main table named bmwtable containing detailed information about each BMW vehicle, including:

Model, Year, Region, Color, Fuel_Type, Transmission,
Engine_Size_L, Mileage_KM, Price_USD, Sales_Volume, Sales_Classification.

2.Defined appropriate data types and ensured a clean structure using CREATE TABLE and SELECT * checks.

3.Verified that the dataset supports multi-dimensional analysis across regions, time, and vehicle specifications.

---

## 🔍 Key Analytical Insights
## .Pricing Analysis

## 1.Average price per fuel type:
```sql
SELECT fuel_type, ROUND(AVG(price_usd)::numeric,2) AS average_price
FROM bmwtable
GROUP BY fuel_type;
```

## 2.Average price by transmission (for engines > 2L):
```sql
SELECT transmission, ROUND(AVG(price_usd)::numeric,2) AS average_price
FROM bmwtable
WHERE engine_size_l > 2
GROUP BY transmission;
```

## Regional and Model Performance

## 1.Total cars by region:
```sql
SELECT region, COUNT(*) AS total_cars FROM bmwtable GROUP BY region;
```

## 2.Top 3 models by sales volume in each region:
```sql
WITH ranked AS (
    SELECT model, region, sales_volume,
           ROW_NUMBER() OVER(PARTITION BY region ORDER BY sales_volume DESC) AS ranking
    FROM bmwtable
)
SELECT * FROM ranked WHERE ranking <= 3;
```

## Color and Sales Behavior

## 1.Percentage of red cars per classification and region:
```sql
WITH total AS (
    SELECT sales_classification, region, COUNT(*) AS total_counter
    FROM bmwtable GROUP BY 1,2
),
red AS (
    SELECT sales_classification, region, COUNT(*) AS red_counter
    FROM bmwtable WHERE color = 'Red' GROUP BY 1,2
)
SELECT t.sales_classification, t.region,
       ROUND((r.red_counter::numeric / t.total_counter::numeric) * 100,1) AS percentage_of_red_cars
FROM total t LEFT JOIN red r
ON t.region = r.region AND t.sales_classification = r.sales_classification;
```

## Time-Based Insights

## 1.Year-over-Year growth in average price by region:## Sales Trends
```sql
WITH yearly AS (
    SELECT year, region,
           ROUND(AVG(price_usd)::numeric,1) AS average_price,
           ROUND(LAG(AVG(price_usd)) OVER (PARTITION BY region ORDER BY year),1) AS last_year
    FROM bmwtable GROUP BY 1,2
)
SELECT year, region, average_price, last_year,
       (average_price - last_year) / last_year * 100 AS growth
FROM yearly WHERE last_year IS NOT NULL;
```

## 2.Top 3 models that appreciated the most in value (used market):
```sql
WITH yearly AS (
    SELECT year, model,
           ROUND(AVG(price_usd)) AS average_price,
           ROUND(LAG(AVG(price_usd)) OVER(PARTITION BY model ORDER BY year)) AS last_year
    FROM bmwtable GROUP BY 1,2
)
SELECT year, model, average_price, last_year,
       (average_price - last_year) / last_year * 100 AS appreciation
FROM yearly
WHERE last_year IS NOT NULL
ORDER BY year DESC, appreciation DESC;
```

## Performance by Specifications

## 1.Average price & sales by fuel type and transmission:
```sql
SELECT fuel_type, transmission,
       ROUND(AVG(price_usd)::numeric,2) AS avg_price,
       ROUND(AVG(sales_volume)::numeric,2) AS avg_sales
FROM bmwtable GROUP BY fuel_type, transmission;
```

## 2.Average mileage by engine size and region:
```sql
SELECT engine_size_l, region, ROUND(AVG(mileage_km)::numeric) AS avg_mileage
FROM bmwtable GROUP BY 1,2 ORDER BY 2,1;
```

## 3.Color distribution by sales classification:
```sql
SELECT sales_classification, color, COUNT(color) AS color_distrib
FROM bmwtable GROUP BY 1,2;
```

## Market Comparison

## 1.Price difference vs. regional average:
```sql
WITH region_avg AS (
    SELECT region, ROUND(AVG(price_usd)::numeric) AS avg_price
    FROM bmwtable GROUP BY 1
),
model_avg AS (
    SELECT model, region, ROUND(AVG(price_usd)::numeric) AS price_model
    FROM bmwtable GROUP BY 1,2
)
SELECT m.model, m.region, m.price_model, r.avg_price,
       (m.price_model - r.avg_price) AS price_diff
FROM region_avg r
JOIN model_avg m ON r.region = m.region
ORDER BY m.region;
```
## 📊 Power BI Visualization

After computing the main KPIs and insights using SQL, I imported the results into Power BI to create a set of interactive dashboards, including:

## -Average Price by Fuel Type.
## -Number of car in each region.
## -Average Price by transmission.
## -Number of color distribution by sales classification.

These visuals helped transform complex data into clear business insights for performance tracking and strategic decisions.

## 📌 Summary

This project provides a comprehensive look at BMW’s market performance, combining SQL-based analysis and Power BI visualization to deliver insights into:

## Pricing dynamics
## Market segmentation
## Model appreciation trends
## Regional sales behavior
## Color and design preferences

The project demonstrates advanced SQL analysis skills and business-oriented data storytelling — essential for data analyst and BI roles.

## 🧰 Tech Stack

   SQL (PostgreSQL / MySQL compatible)
   Data Visualization (Power BI / Tableau optional next step)

## 📫 Connect with Me

   LinkedIn: [Connect with me professionally](https://www.linkedin.com/in/birsanlucian1/)
   
   E-Mail: birsan.lucian04@gmail.com



