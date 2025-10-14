
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

SELECT *
FROM spotifytable;

-- Q1 -- Retrieve the names of all tracks that have more than 1 billion streams.
SELECT
	track,
	stream
FROM spotifytable
WHERE stream > 1000000000;

-- Q2 -- List all albums along with their respective artists.

SELECT DISTINCT
	album,
	artist
FROM spotifytable;

-- Q3 -- Get the total number of comments for tracks where licensed = TRUE.

SELECT 
	SUM(comments) as totalnumber
FROM spotifytable
WHERE licensed = TRUE;

-- Q4 -- Find all tracks that belong to the album type single.

SELECT *
FROM spotifytable
WHERE album_type = 'single';

-- Q5 -- Count the total number of tracks by each artist.

SELECT
	artist,
	COUNT(track) as count_number
FROM spotifytable
GROUP BY artist;

-- Q6 -- Calculate the average danceability of tracks in each album.

SELECT
	album,
	AVG(danceability) as average_dance
FROM spotifytable
GROUP BY album;

-- Q7 -- Find the top 5 tracks with the highest energy values.

SELECT
	track,
	energy
FROM spotifytable
ORDER BY energy DESC
LIMIT 5;

-- Q8 -- List all tracks along with their views and likes where official_video = TRUE.

SELECT
	track,
	views,
	likes
FROM spotifytable
WHERE official_video = TRUE;

-- Q9 -- For each album, calculate the total views of all associated tracks.

SELECT
	artist,
	album,
	SUM(views) as totalviews
FROM spotifytable
GROUP BY album,artist;

-- Q10 -- Retrieve the track names that have been streamed on Spotify more than YouTube.
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

-- Q11 -- Find the top 3 most-viewed tracks for each artist using window functions.
SELECT *
FROM(
SELECT
	artist,
	track,
	views,
	DENSE_RANK () OVER(partition by artist ORDER BY views DESC) as ranking
FROM spotifytable
)t WHERE ranking <= 3;

-- Q12 -- Write a query to find tracks where the liveness score is above the average.

SELECT
	AVG(liveness) 
FROM spotifytable;


SELECT *
FROM spotifytable
WHERE liveness > (SELECT AVG(liveness) FROM spotifytable);

-- Q13 -- Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
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
