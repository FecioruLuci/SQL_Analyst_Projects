CREATE TABLE userr(
id	SERIAL PRIMARY KEY,
user_id	BIGINT, 
question_id	INT,
points	INT,
submitted_at TIMESTAMP WITH TIME ZONE,
username VARCHAR(30)
);

-- Q1 -- List all distinct users and their stats (return user_name, total_submissions, points earned)

SELECT
	DISTINCT(user_id),
	username,
	COUNT(submitted_at) as total_sub,
	SUM(points) as points_earned
FROM userr
GROUP BY 1,2;

-- Q2 -- Calculate the daily average points for each user

SELECT
	username,
	AVG(points),
	EXTRACT (DAY FROM submitted_at) as day,
	EXTRACT (MONTH FROM submitted_at) as month
FROM userr
GROUP BY 1,3,4
ORDER BY 1,4,3 ASC;

-- Q3 -- Find the top 3 users with the most positive submissions for each day
WITH table1 
AS
(
SELECT
	username,
	DATE(submitted_at) dayy,
	SUM(CASE
		WHEN points > 0 THEN 1
		ELSE 0
		END) AS counter
FROM userr
GROUP BY 2,1
),
table2
AS
(
SELECT 
	username,
	dayy,
	counter,
	DENSE_RANK() OVER(PARTITION BY dayy ORDER BY counter DESC) ranking
FROM table1
)
SELECT 	
	table2.username,
	table2.dayy,
	table2.counter,
	ranking
FROM table2
WHERE ranking <= 3
