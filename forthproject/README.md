# Spotify Advanced SQL Project and Query Optimization
Project Category: Advanced
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![Spotify Logo](https://github.com/FecioruLuci/SQL_Analyst_Projects/blob/main/forthproject/myspotify.jpg)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
CREATE DATABASE spotify;

DROP TABLE IF EXISTS spotifytable;
CREATE table spotifytable(
	Artist	VARCHAR(50),
	Track	VARCHAR(250),
	Album	VARCHAR(250),
	Album_type	VARCHAR(25),
	Danceability	FLOAT,
	Energy	FLOAT,
	Loudness	FLOAT,
	Speechiness	FLOAT,
	Acousticness	FLOAT,
	Instrumentalness	FLOAT,
	Liveness	FLOAT,
	Valence	FLOAT,	
	Tempo	FLOAT,
	Duration_min	FLOAT,
	Title	VARCHAR(250),
	Channel	VARCHAR(100),
	Views	BIGINT,
	Likes	BIGINT,
	Comments	BIGINT,
	Licensed	BOOLEAN,
	official_video	BOOLEAN,
	Stream	BIGINT,
	EnergyLiveness	FLOAT,
	most_playedon	VARCHAR(50)
);
```

1. **-- Q1 -- Retrieve the names of all tracks that have more than 1 billion streams.**
```sql
SELECT
	track,
	stream
FROM spotifytable
WHERE stream > 1000000000;
```

2. **-- Q2 -- List all albums along with their respective artists.**
```sql
SELECT DISTINCT
	album,
	artist
FROM spotifytable;
```

3. **-- Q3 -- Get the total number of comments for tracks where licensed = TRUE.**
```sql
SELECT 
	SUM(comments) as totalnumber
FROM spotifytable
WHERE licensed = TRUE;

```

4. **-- Q4 -- Find all tracks that belong to the album type single.**
```sql
SELECT *
FROM spotifytable
WHERE album_type = 'single';

```

5. **-- Q5 -- Count the total number of tracks by each artist.**
```sql
SELECT
	artist,
	COUNT(track) as count_number
FROM spotifytable
GROUP BY artist;


```

6. **-- Q6 -- Calculate the average danceability of tracks in each album.**
```sql
SELECT
	album,
	AVG(danceability) as average_dance
FROM spotifytable
GROUP BY album;


```

7. **-- Q7 -- Find the top 5 tracks with the highest energy values.**
```sql
SELECT
	track,
	energy
FROM spotifytable
ORDER BY energy DESC
LIMIT 5;


```

8. **-- Q8 -- List all tracks along with their views and likes where official_video = TRUE.**
```sql
SELECT
	track,
	views,
	likes
FROM spotifytable
WHERE official_video = TRUE;

```

9. **-- Q9 -- For each album, calculate the total views of all associated tracks.**
```sql
SELECT
	artist,
	album,
	SUM(views) as totalviews
FROM spotifytable
GROUP BY album,artist;

```

10. **-- Q10 -- Retrieve the track names that have been streamed on Spotify more than YouTube.**
```sql
SELECT *
FROM(

SELECT
	track,
	COALESCE(SUM(CASE WHEN most_playedon = 'Youtube' THEN stream END),0) AS ytb_views,
	COALESCE(SUM(CASE WHEN most_playedon = 'Spotify' THEN stream END),0) AS spoty_views
FROM spotifytable
GROUP BY track
)t WHERE spoty_views > ytb_views
	AND
	ytb_views != 0;

```

11. **-- Q11 -- Find the top 3 most-viewed tracks for each artist using window functions.**
```sql
SELECT *
FROM(
SELECT
	artist,
	track,
	views,
	DENSE_RANK () OVER(partition by artist ORDER BY views DESC) as ranking
FROM spotifytable
)t WHERE ranking <= 3;

```

12. **-- Q12 -- Write a query to find tracks where the liveness score is above the average.**
```sql
SELECT
	AVG(liveness) 
FROM spotifytable;


SELECT *
FROM spotifytable
WHERE liveness > (SELECT AVG(liveness) FROM spotifytable);

```

13. **-- Q13 -- Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
WITH table1
AS(
SELECT 
	album,
	MAX(energy) as max_energy,
	MIN(energy) as low_energy
FROM spotifytable
GROUP BY album
)

SELECT
	album,
	max_energy - low_energy as difference_of_energy
FROM table1
ORDER BY max_energy - low_energy DESC;

```
## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## Author - Birsan Lucian

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. Thank you for watching.

- **LinkedIn**: [[Connect with me professionally](https://www.linkedin.com/in/najirr](https://github.com/FecioruLuci))
- **Email**: birsan.lucian04@gmail.com



