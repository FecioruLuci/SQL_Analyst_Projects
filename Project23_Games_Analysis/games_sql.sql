CREATE TABLE games(
img	VARCHAR(150),
title	VARCHAR(150),
console	VARCHAR(10),
genre	VARCHAR(20),
publisher	VARCHAR(50),
developer	VARCHAR(75),
critic_score	FLOAT,
total_sales	FLOAT,
na_sales	FLOAT,
jp_sales	FLOAT,
pal_sales	FLOAT,
other_sales	FLOAT,
release_date	DATE,
last_update	DATE
)

-- 1  Record Count: How many total games are recorded in the dataset?

SELECT
	COUNT(DISTINCT title) AS total_distinct_games,
	COUNT(*) AS total_games_with_different_platform
FROM games

-- 2 Top Performers: List the top 10 games by total_sales in descending order.
SELECT
	*
FROM
(
SELECT
	title,
	total_sales,
	RANK() OVER(ORDER BY total_sales DESC) as ranking
FROM games
)
WHERE ranking <= 10

-- 3  Filtering: Retrieve all games developed by 'Rockstar Games'.

SELECT
	DISTINCT(title, publisher) AS rockstart_games
FROM games
WHERE publisher = 'Rockstar Games'

-- 4  Platform Specifics: How many games were released specifically for the 'PS4' console?

SELECT
	COUNT(title)
FROM games
WHERE console = 'PS4'

-- 5  Quality Check: Find all games with a critic_score higher than 9.0.

SELECT
	*
FROM games
WHERE critic_score > 9.0

-- 6  Market Totals: What are the total sales specifically for the Japanese market (jp_sales)?

SELECT
	ROUND(SUM(jp_sales)::numeric,2) AS total_jp_sales
FROM games

-- 7  Missing Data: List all games where the critic_score is NULL.

SELECT *
FROM games
WHERE critic_score IS NULL OR
	critic_score = 0

-- 8  Publisher Variety: How many unique publishers are present in the table?

SELECT
	COUNT(DISTINCT publisher) AS unique_publishers
FROM games

-- 9  Oldest Game: Find the title and release_date of the oldest game in the dataset.

SELECT
	title,
	release_date
FROM games
WHERE release_date IS NOT NULL
ORDER BY 2 ASC
LIMIT 1


SELECT
	title,
	release_date,
	RANK() OVER(ORDER BY release_date ASC)
FROM games
WHERE release_date IS NOT NULL
LIMIT 1

-- 10  Specific Genre: List all 'Action' games released after January 1st, 2015.

SELECT
	title,
	genre,
	release_date
FROM games
WHERE genre = 'Action' AND release_date > '01/01/2015'
ORDER BY 3 ASC

-- 11  Platform Analysis: Calculate the average critic_score for each console. Which one has the highest?

SELECT
	console,
	ROUND(AVG(critic_score)::numeric,2) AS avg_score
FROM games
WHERE critic_score IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC

-- 12  Genre Popularity: Which genre has generated the most total_sales globally?

SELECT
	genre,
	ROUND(SUM(total_sales)::numeric,2) AS total_sales_per_genre
FROM games
WHERE total_sales != 0
GROUP BY 1
ORDER BY 2 DESC

-- 13  Regional Dominance: For each game, calculate what percentage of total_sales comes from na_sales.
WITH table1
AS
(
SELECT
	title,
	SUM(total_sales) as total_saless,
	SUM(na_sales) AS total_na_sales
FROM games
WHERE total_sales != 0 AND
	na_sales != 0
GROUP BY 1
)

SELECT
	t1.title,
	ROUND(((total_saless - total_na_sales) / total_saless * 100)::numeric,2) AS percentage
FROM table1 AS t1
ORDER BY 2 DESC

-- 14  Publisher Volume: Identify publishers who have released more than 50 games.

SELECT
	publisher,
	COUNT(title) AS nr_of_released_games
FROM games
GROUP BY 1
HAVING COUNT(title) > 50

-- 15  Yearly Trends: Group the data by year (from release_date) and show the total games released each year.

SELECT
	EXTRACT(YEAR FROM release_date) AS yearr,
	COUNT(DISTINCT title) AS games_released
FROM games
WHERE release_date IS NOT NULL
GROUP BY 1

-- 16  Update Latency: Calculate the average number of days between the release_date and the last_update.
with table1
AS
(
SELECT
	last_update - release_date AS days_diff
FROM games
WHERE last_update IS NOT NULL AND
	release_date IS NOT NULL
)

SELECT
	ROUND(AVG(days_diff)::numeric) AS avg_days
FROM table1

-- 17  High Stakes: Find the developer with the highest average total_sales (minimum 5 games released).

SELECT
	developer,
	ROUND(AVG(total_sales)::numeric,2) AS avg_total_sales
FROM games
WHERE total_sales IS NOT NULL
GROUP BY 1
HAVING COUNT(DISTINCT title) >= 5
ORDER BY 2 DESC

-- 18  Comparison: List games where pal_sales (Europe) are higher than na_sales (North America).

SELECT
	title,
	pal_sales,
	na_sales
FROM games
WHERE pal_sales > na_sales AND
	pal_sales IS NOT NULL AND
	na_sales IS NOT NULL

-- 19  Categorization: Use a CASE statement to label games as 'High Scored' (score > 8.0) or 'Low Scored' (score <= 8.0).

SELECT
	*,
	CASE
	WHEN critic_score > 8.0 THEN 'High Scored'
	WHEN critic_score <= 8.0 THEN 'Low Scored'
	ELSE 'No score'
	END AS segmentation
FROM games

-- 20  Market Share: Find the top 3 publishers in terms of total jp_sales.
SELECT *
FROM
(
SELECT
	publisher,
	jp_sales,
	DENSE_RANK() OVER(ORDER BY jp_sales DESC) AS ranking
FROM games
)
WHERE ranking <= 3