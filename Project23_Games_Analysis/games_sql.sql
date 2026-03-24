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

