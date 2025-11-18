## 📊 Mobile Phone Market Analysis Project
This project provides a comprehensive analysis of mobile phone specifications, pricing trends, and market performance across various brands and models. The analysis leverages SQL to extract valuable insights about product features, customer preferences, and competitive positioning in the smartphone industry.

## 🎯 Power BI Dashboard Overview
I developed an interactive Power BI dashboard that provides comprehensive insights into the mobile phone market, enabling users to explore and analyze device specifications, pricing trends, and brand performance through dynamic visualizations and filters.

## 📱 Key Dashboard Features
## Core Metrics & KPI Tracking

1.Total Phones - Complete device count across all brands
2.5G Supported Devices - Number of phones with 5G capability
3.Average Price per Brand - Comparative pricing analysis
4.Monthly Release Trends - Product launch patterns throughout the year

## Advanced Device Filtering

1.Budget Phones - Devices priced under $500
2.Performance Models - Phones with more than 8GB RAM
3.Battery Capacity Analysis - Phone battery performance by model
4.Brand-Specific Insights - Filterable data for individual manufacturers
---

## 📱 Dataset Overview
Created and analyzed a detailed phones dataset with the following specifications:
```sql
DROP TABLE IF EXISTS phones;
CREATE TABLE phones(
    brand VARCHAR(25),
    model VARCHAR(25),
    price_usd INT,
    ram_gb INT,
    storage_gb INT,
    camera_mp INT,
    battery_mah INT,
    display_size_inch FLOAT,
    charging_watt INT,
    fiveg_support VARCHAR(10),
    os VARCHAR(25),
    processor VARCHAR(25),
    rating FLOAT,
    release_month VARCHAR(25),    
    year INT
);
```

## 🎯 Key Analytical Queries
1. Market Segmentation & Brand Performance

```sql
-- Brand market share and average pricing
SELECT
    brand,
    COUNT(model) AS model_count,
    ROUND(AVG(price_usd)::numeric,1) AS avg_price,
    ROUND(AVG(rating)::numeric,2) AS avg_rating
FROM phones
GROUP BY brand
ORDER BY model_count DESC;
```
2. Technology Adoption Trends


```sql
-- 5G penetration analysis
SELECT
    fiveg_support,
    COUNT(*) AS device_count,
    ROUND(AVG(price_usd)::numeric,1) AS avg_price
FROM phones
GROUP BY fiveg_support;

-- Processor performance categorization
SELECT
    processor,
    CASE
        WHEN processor = 'Snapdragon 6 Gen 1' THEN 'Low'
        WHEN processor = 'Snapdragon 8 Gen 3' THEN 'High'
        ELSE 'Medium'
    END AS performance_tier,
    ROUND(AVG(price_usd)::numeric,2) AS avg_price
FROM phones
GROUP BY processor;
```

3. Advanced Statistical Analysis

```sql
-- Camera-to-display ratio (imaging efficiency)
SELECT
    brand,
    ROUND(AVG(camera_mp / display_size_inch)::numeric,2) AS imaging_ratio
FROM phones
GROUP BY brand
ORDER BY imaging_ratio DESC
LIMIT 5;

-- Battery vs Display correlation
SELECT
    brand,
    ROUND(CORR(battery_mah, display_size_inch)::numeric,3) AS battery_display_correlation
FROM phones
GROUP BY brand;
```

4. Product Performance Insights

```sql
-- Top performers by brand
SELECT *
FROM (
    SELECT
        brand,
        model,
        rating,
        price_usd,
        ROW_NUMBER() OVER(PARTITION BY brand ORDER BY rating DESC, price_usd DESC) AS ranking
    FROM phones
) ranked_phones
WHERE ranking <= 3;

-- Price outlier detection
WITH brand_stats AS (
    SELECT 
        PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY battery_mah) AS battery_threshold,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY charging_watt) AS charging_threshold
    FROM phones
)
SELECT 
    brand,
    model,
    battery_mah,
    charging_watt
FROM phones, brand_stats
WHERE battery_mah > brand_stats.battery_threshold
    AND charging_watt < brand_stats.charging_threshold;
```

## 📊 Key Findings & Business Insights
## Market Structure
Comprehensive brand portfolio analysis
Price segment distribution
Technology adoption rates

## Consumer Value Propositions
Best price-to-performance devices
Premium feature analysis
Budget segment opportunities

## Product Development Insights
Optimal specification combinations
Feature prioritization based on pricing
Competitive positioning strategies


## 🛠 Technical Implementation
SQL Features Utilized:
Window Functions (ROW_NUMBER, LAG)
Statistical Aggregates (PERCENTILE_CONT, CORR)
Advanced Filtering (CTEs, Subqueries)
Conditional Logic (CASE statements)
Time-series Analysis

## 📌 Project Summary
This project provides a comprehensive data-driven analysis of the mobile phone market, delivering valuable insights across multiple dimensions:
    -Market Structure & Brand Performance - Comprehensive analysis of brand positioning, pricing strategies, and market share distribution
    -Technology Adoption Trends - 5G penetration rates, processor performance tiers, and feature evolution across price segments
    -Product Specification Analysis - Camera capabilities, battery performance, display technologies, and charging innovations
    -Consumer Value Assessment - Price-to-performance ratios, premium feature analysis, and budget segment opportunities
    -Competitive Intelligence - Product benchmarking, specification comparisons, and market positioning strategies

## 🧰 Tech Stack

   SQL (PostgreSQL / MySQL compatible)
   Data Visualization (Power BI)

## 📫 Connect with Me

   LinkedIn: [Connect with me professionally](https://www.linkedin.com/in/birsanlucian1/)
   
   E-Mail: birsan.lucian04@gmail.com



