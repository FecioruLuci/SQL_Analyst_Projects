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

SELECT *
FROM netflix

-- Q1 -- Count the Number of Movies vs TV Shows

SELECT
	type,
	COUNT(*)
FROM netflix
GROUP BY type;

-- Q2 -- Find the Most Common Rating for Movies and TV Shows
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

-- Q3 -- List All Movies Released in a Specific Year (e.g., 2020)

SELECT *
FROM netflix
WHERE release_year = 2020;

-- Q4 -- Find the Top 5 Countries with the Most Content on Netflix

SELECT
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(*) as counter
FROM netflix
WHERE COUNTRY IS NOT NULL
GROUP BY UNNEST(STRING_TO_ARRAY(country, ','))
ORDER BY COUNT(*) DESC
LIMIT 5;

-- Q5 Identify the Longest Movie

SELECT
	*
FROM netflix
WHERE 
	type = 'Movie'
	and
	duration = (SELECT MAX(duration) FROM netflix);

	