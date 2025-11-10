## 🍕 Pizza Sales Analysis Project

This project focuses on exploring and analyzing a pizza sales dataset to uncover insights about revenue trends, customer ordering behavior, and product performance. The analysis is performed using SQL to calculate key performance metrics and visualize patterns across categories, sizes, and time periods.

---

## 📊 Data Preparation

Created a main table named pizzatable, containing detailed transactional data with the following fields:

pizza_id, order_id, pizza_name_id, quantity, order_date, order_time,
unit_price, total_price, pizza_size, pizza_category,
pizza_ingredients, pizza_name.

Ensured data integrity by defining appropriate data types and primary keys.

Verified data consistency using SELECT * FROM pizzatable; before proceeding with analysis. 

---

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
## 📈 Product and Customer Performance

1. Identified the **top 10 customers generating the highest revenue**.  
2. Identified the **3 customers with the fewest orders**.  
3. Determined the **5 worst-performing products** based on sales revenue.  
4. Analyzed **sales performance over time** by day, month, and year.  
5. Compared each product’s **yearly sales** to its **average sales** and **previous year’s sales** to identify trends.  
6. Determined **categories contributing most to overall sales** and their **percentage share**.  
7. Segmented products into **cost ranges** (`LOW`, `MEDIUM`, `HIGH`) and counted products in each segment.  

---

## 👥 Customer Segmentation

1. Grouped customers into three segments based on **spending behavior and lifespan**:  

   - **VIP:** ≥12 months of history and total spending > $5000  
   - **Regular:** ≥12 months of history and total spending < $5000  
   - **New:** lifespan < 12 months  

2. Computed additional customer metrics:  

   - **Age group:** `YOUNG (<25)`, `ADULT (25–40)`, `OLD (>40)`  
   - **Total orders and total sales per customer**  
   - **Total quantity purchased**  
   - **Lifespan in months** (time between first and last order)  
   - **Recency:** months since last order  
   - **Average order value** and **average monthly spend**  

---

## 📌 Summary

This project provides a comprehensive overview of **sales and customer behavior**, offering actionable insights for:  

- **Marketing strategies**  
- **Product management**  
- **Customer relationship management**  

By combining transaction data with customer and product attributes, the analysis enables **data-driven decision-making** to maximize revenue and improve customer engagement.  

This project is part of my portfolio, showcasing the **SQL skills essential for data analyst roles**.  

---

## 📫 Connect with Me

- **LinkedIn:** [Connect with me professionally](https://www.linkedin.com/in/birsanlucian1/)  
- **E-Mail:** birsan.lucian04@gmail.com  

