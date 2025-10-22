# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/FecioruLuci/SQL_Analyst_Projects/blob/main/thirdproject/netflixphoto.jpg)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql

CREATE DATABASE thirdproject;

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix(
	show_id	VARCHAR(10) PRIMARY KEY,
	type	VARCHAR(10),
	title	VARCHAR(125),
	director	VARCHAR(225),
	casts	VARCHAR(775),
	country	VARCHAR(125),
	date_added	VARCHAR(50),
	release_year	INT,
	rating	VARCHAR(10),
    duration	VARCHAR(15),
	listed_in	VARCHAR(100),
	description	VARCHAR(275)
);

```

## Business Problems and Solutions

-- Q1 -- Count the Number of Movies vs TV Shows

```sql
SELECT
	type,
	COUNT(*)
FROM netflix
GROUP BY type;
```

-- Q2 -- Find the Most Common Rating for Movies and TV Shows

```sql
SELECT
	type,
	rating,
	counter
FROM(
SELECT
	type,
	rating,
	COUNT(*) as counter,
	RANK () OVER (partition by type ORDER BY COUNT(*) DESC) as ranking
FROM netflix
GROUP BY rating,type
)t WHERE ranking = 1;
```

-- Q3 -- List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT *
FROM netflix
WHERE release_year = 2020;

```

-- Q4 -- Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(*) as counter
FROM netflix
WHERE COUNTRY IS NOT NULL
GROUP BY UNNEST(STRING_TO_ARRAY(country, ','))
ORDER BY COUNT(*) DESC
LIMIT 5;
```

-- Q5 Identify the Longest Movie

```sql
SELECT
	*
FROM netflix
WHERE 
	type = 'Movie'
	AND duration IS NOT NULL
ORDER BY SPLIT_PART(duration, ' ',1)::INT DESC
```

-- Q6 -- Find Content Added in the Last 5 Years

```sql
SELECT
	title,
	daytime
FROM(
SELECT
	title,
    TO_DATE(date_added, 'Month DD, YYYY') AS daytime
FROM netflix
)t WHERE daytime >= CURRENT_DATE - INTERVAL '5 years';
```

-- Q7 -- Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM(
SELECT
	title,
	UNNEST(STRING_TO_ARRAY(director, ',')) as new_director
FROM netflix
)t WHERE new_director = 'Rajiv Chilaka';
```

-- Q8 -- List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ',1)::INT > 5;

```

-- Q9 -- Count the Number of Content Items in Each Genre

```sql
SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as new_list,
	COUNT(*)
FROM netflix
GROUP BY UNNEST(STRING_TO_ARRAY(listed_in, ','));
```

-- Q10 -- Find each year and the average numbers of content release in India on netflix and return top 5 year with highest avg content release!

```sql
SELECT 
	*,
	ROUND(counter::numeric / 972 * 100,2) as average_numbers
FROM(
SELECT
	release_year,
	COUNT(*) as counter
FROM netflix
WHERE country = 'India'
GROUP BY release_year
)t ORDER BY average_numbers DESC
LIMIT 5
```

-- Q11 -- List All Movies that are Documentaries

```sql
SELECT
	DISTINCT(UNNEST(STRING_TO_ARRAY(listed_in, ',')))
FROM netflix;

SELECT *
FROM netflix
WHERE type = 'Movie'
	AND listed_in LIKE '%Documentaries%';

```

-- Q12 -- Find All Content Without a Director

```sql
SELECT *
FROM netflix
WHERE director IS NULL;

```

-- Q13 Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT *
FROM netflix
WHERE casts LIKE '%Salman Khan%'
AND TO_DATE(date_added, 'MONTH DD, YYYY') >= (CURRENT_DATE - INTERVAL '10 years');
```

-- Q14 -- Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
	COUNT(*)
FROM netflix
WHERE country = 'India'
AND type = 'Movie'
GROUP BY UNNEST(STRING_TO_ARRAY(casts, ','))
ORDER BY COUNT(*) DESC
LIMIT 10;
```

-- Q15 -- Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

```sql
SELECT
	DISTINCT(UNNEST(STRING_TO_ARRAY(listed_in, ','))) as genre
FROM netflix;


SELECT COUNT(*),
Categoryy
FROM(
SELECT *,
CASE WHEN description ILIKE '%KILL%' THEN 'Bad'
WHEN description ILIKE '%Violence%' THEN 'Good'
ELSE 'normal'
END AS Categoryy
FROM netflix
)t GROUP BY Categoryy;
-- checked and it's working
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Birsan Lucian

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. Thank you for watching.

- **LinkedIn**: [[Connect with me professionally]) -    https://www.linkedin.com/in/birsanlucian1/
- **E-Mail**: birsan.lucian04@gmail.com




