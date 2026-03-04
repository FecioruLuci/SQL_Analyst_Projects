DROP TABLE IF EXISTS phoneanal
CREATE TABLE phoneanal (
user_id	VARCHAR(25),
age	INT,
gender	VARCHAR(25),
occupation	VARCHAR(25),
device_type	VARCHAR(25),
daily_phone_hours	INT,
social_media_hours	INT,
work_productivity_score	INT,
sleep_hours	INT,
stress_level	INT,
app_usage_count	INT,
caffeine_intake_cups	INT,	
weekend_screen_time_hours	INT

)

SELECT *
FROM phoneanal

-- 1.  General Usage: What is the average daily_phone_hours across the entire dataset?

SELECT
	ROUND(AVG(daily_phone_hours)::numeric,2) AS avg_daily_hours
FROM phoneanal

-- 2. Demographics: What is the gender distribution among the surveyed users?

SELECT
	DISTINCT gender
FROM phoneanal

-- 3. App Engagement: Which occupation has the highest mean app_usage_count?

SELECT
	occupation,
	ROUND(AVG(app_usage_count)::numeric,2) AS avg_app_usage
FROM phoneanal
GROUP BY 1
ORDER BY 2 DESC

-- 4. Device Preference: How many users are on iOS vs. Android (based on device_type)?

SELECT
	device_type,
	COUNT(user_id) AS nr_of_users
FROM phoneanal
GROUP BY 1

--  5.  Health Baseline: What is the average number of sleep_hours for the total population?

SELECT
	ROUND(AVG(sleep_hours)::numeric,1) AS avg_sleep
FROM phoneanal

-- 6.  Productivity Range: What are the minimum and maximum values for the work_productivity_score?

SELECT
	MIN(work_productivity_score) AS min_productivity_hours,
	MAX(work_productivity_score) AS max_productivity_hours
FROM phoneanal

--  7.  Caffeine Habits: What is the most common number of caffeine_intake_cups reported?

SELECT
	caffeine_intake_cups,
	COUNT(caffeine_intake_cups) AS number_if_caffeine_cups
FROM phoneanal
GROUP BY 1
ORDER BY 2 DESC

--  8. Weekend vs. Weekday: What is the average weekend_screen_time_hours compared to the daily average?
SELECT
	ROUND(AVG(daily_phone_hours)::numeric,2) AS daily_phone_hours,
	ROUND(AVG(weekend_screen_time_hours)::numeric,2) AS weekend_phone_hours
FROM phoneanal

-- 9. Stress Check: How many users report a stress_level above 7 (on a scale of 1-10)?

SELECT
	COUNT(*) AS big_stress_level
FROM phoneanal
WHERE stress_level > 7

-- 10. Age Groups: What is the average age of the users in this dataset?

SELECT
	ROUND(AVG(age)::numeric) AS avg_age
FROM phoneanal

-- 11. Social Media & Stress: Is there a positive correlation between social_media_hours and stress_level?

SELECT
	CORR(social_media_hours,stress_level) AS correlation
FROM phoneanal

--  12. The "Sleep Debt": Do users who spend more than 5 hours on social media sleep significantly less than 
-- those who spend less than 2 hours?
WITH table1
AS
(
SELECT
	ROUND(AVG(sleep_hours)::numeric,2) AS avg_sleep_more
FROM phoneanal
WHERE social_media_hours > 5
),

table2
AS
(
SELECT
	ROUND(AVG(sleep_hours)::numeric,2) AS avg_sleep_less
FROM phoneanal
WHERE social_media_hours < 2
)

SELECT
	avg_sleep_more,
	avg_sleep_less
FROM table1,table2

-- 13.  Productivity Impact: Is there a visible drop in work_productivity_score as daily_phone_hours increases?

SELECT
	CORR(work_productivity_score, daily_phone_hours) AS corr
FROM phoneanal
-- there is no visible drop between work productibity and daily phone hours. Our corelation coeficient is -0.002

-- 14. Caffeine & Sleep: How do sleep_hours fluctuate across different levels of caffeine_intake_cups?

SELECT
	caffeine_intake_cups,
	ROUND(AVG(sleep_hours)::numeric,2) AS avg_sleep,
	COUNT(*)
FROM phoneanal
GROUP BY 1
-- all the people with caffeine intake from 1 to 6 have the same avg_sleep so there is no fluctuate between those.

-- 15.  Screen Time Ratio: What percentage of total daily_phone_hours is dedicated specifically to 
-- social_media_hours for each occupation?

SELECT
	occupation,
	ROUND(SUM(social_media_hours):: numeric / SUM(daily_phone_hours)::numeric * 100,2) AS percentage
FROm phoneanal
GROUP BY 1

-- 16.  Generation Gap: Compare the app_usage_count between users under 25 and users over 45.

SELECT
	ROUND(AVG(
	CASE
	WHEN age < 25 THEN app_usage_count END)::numeric,2) AS underr,
	ROUND(AVG(
	CASE
	WHEN age > 45 THEN app_usage_count END)::numeric,2) AS overr
FROM phoneanal

SELECT *
FROM phoneanal
