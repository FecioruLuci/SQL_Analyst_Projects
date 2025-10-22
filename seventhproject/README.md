# SQL Mentor User Performance Analysis

## Project Overview

This project is designed to help beginners understand SQL querying and performance analysis using real-time data from SQL Mentor datasets. In this project, you will analyze user performance by creating and querying a table of user submissions. The goal is to solve a series of SQL problems to extract meaningful insights from user data.

## Objectives

- Learn how to use SQL for data analysis tasks such as aggregation, filtering, and ranking.
- Understand how to calculate and manipulate data in a real-world dataset.
- Gain hands-on experience with SQL functions like `COUNT`, `SUM`, `AVG`, `EXTRACT()`, and `DENSE_RANK()`.
- Develop skills for performance analysis using SQL by solving different types of data problems related to user performance.

## SQL Mentor User Performance Dataset

The dataset consists of information about user submissions for an online learning platform. Each submission includes:
- **User ID**
- **Question ID**
- **Points Earned**
- **Submission Timestamp**
- **Username**

This data allows you to analyze user performance in terms of correct and incorrect submissions, total points earned, and daily/weekly activity.

## Key SQL Concepts Covered

- **Aggregation**: Using `COUNT`, `SUM`, `AVG` to aggregate data.
- **Date Functions**: Using `EXTRACT()` and `TO_CHAR()` for manipulating dates.
- **Conditional Aggregation**: Using `CASE WHEN` to handle positive and negative submissions.
- **Ranking**: Using `DENSE_RANK()` to rank users based on their performance.
- **Group By**: Aggregating results by groups (e.g., by user, by day, by week).

## SQL Queries Solutions

Below are the solutions for each question in this project:

### -- Q1 -- List all distinct users and their stats (return user_name, total_submissions, points earned)
```sql
SELECT
	DISTINCT(user_id),
	username,
	COUNT(submitted_at) as total_sub,
	SUM(points) as points_earned
FROM userr
GROUP BY 1,2;
```

### -- Q2 -- Calculate the daily average points for each user

```sql
SELECT
	username,
	AVG(points),
	EXTRACT (DAY FROM submitted_at) as day,
	EXTRACT (MONTH FROM submitted_at) as month
FROM userr
GROUP BY 1,3,4
ORDER BY 1,4,3 ASC;

```

### -- Q3 -- Find the top 3 users with the most positive submissions for each day
```sql
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
WHERE ranking <= 3;
```

### -- Q4 -- Find the top 5 users with the highest number of incorrect submissions
```sql
WITH table1 
AS
(
SELECT 	
	username as namee,
	SUM(CASE
	WHEN points < 0 THEN 1
	ELSE 0
	END) AS counter
FROM userr
GROUP BY 1
),
table2 
AS
(
SELECT
	namee,
	counter,
	DENSE_RANK () OVER(ORDER BY counter DESC) as ranking
FROM table1
)

SELECT
	table2.namee,
	table2.counter,
	table2.ranking
FROM table2
WHERE ranking <= 5
```

### -- Q5 -- Find the top 10 performers for each week
```sql
WITH table1
AS
(
SELECT 
	username,
	SUM(points) as points,
	EXTRACT (WEEK FROM submitted_at) as week
FROM userr
GROUP BY 3,1
),
table2
AS
(
SELECT
	table1.username,
	table1.points,
	table1.week,
	DENSE_RANK() OVER(PARTITION BY week ORDER BY table1.points DESC) as ranking
FROM table1
)
SELECT
	table2.username,
	table2.points,
	table2.week,
	table2.ranking
FROM table2
WHERE table2.ranking <= 10;
```

## Conclusion

This project provides an excellent opportunity for beginners to apply their SQL knowledge to solve practical data problems. By working through these SQL queries, you'll gain hands-on experience with data aggregation, ranking, date manipulation, and conditional logic.

## Author - Birsan Lucian

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. Thank you for watching.

- **LinkedIn**: [[Connect with me professionally]) -    https://www.linkedin.com/in/birsanlucian1/
- **E-Mail**: birsan.lucian04@gmail.com


Thank you for your support, and I look forward to connecting with you!
