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

-- 17.  Weekend Surge: Which occupation shows the highest increase in screen time during the weekend compared to weekdays?

SELECT
	occupation,
	ROUND(AVG(daily_phone_hours)::numeric,2) AS avg_daily,
	ROUND(AVG(weekend_screen_time_hours)::numeric,2) AS weekend_hours,
	ROUND(AVG(weekend_screen_time_hours)::numeric - AVG(daily_phone_hours)::numeric,2) AS screen_time_difference
FROM phoneanal
GROUP BY 1
ORDER BY 4 DESC

-- 18.  Stress by Device: Does stress_level vary significantly between different device_type users?

SELECT
	device_type,
	ROUND(AVG(stress_level)::numeric,2) AS avg_stress
FROM phoneanal
GROUP BY 1
-- we get avg stress of 5.50 for ios and 5.51 for android so the stress level doen not vary

-- 19.  The "Doomscrolling" Indicator: Is a high app_usage_count more closely linked to stress_level or social_media_hours?
-- app usage count = 32.
SELECT
	CASE
	WHEN app_usage_count > 45 THEN 'Very High'
	ELSE 'High'
	END AS usage_category,
	ROUND(AVG(stress_level)::numeric,2) AS avg_stress,
	ROUND(AVG(social_media_hours)::numeric,2) AS avg_social
FROM phoneanal
WHERe app_usage_count > 32
GROUP BY 1
-- for both stress and social hours the avg is that same based on app usage count.

-- 20.  Productivity & Sleep: Identify the "Sweet Spot"—what number of sleep_hours is associated with the highest 
-- average work_productivity_score?

SELECT
	sleep_hours,
	ROUND(AVG(work_productivity_score)::numeric,2) AS avg_work_score,
	COUNT(*)
FROM phoneanal
GROUP BY 1
ORDER BY 2 DESC

-- 21.  The Efficiency Paradox: Identify users who have high daily_phone_hours but still maintain a high work_productivity_score. 
-- What are their common characteristics (age, occupation, sleep)?

SELECT
	user_id,
	age,
	occupation,
	sleep_hours,
	daily_phone_hours,
	work_productivity_score AS avg_work_score
FROM phoneanal
WHERE daily_phone_hours > 5
AND
work_productivity_score > 8
ORDER BY 5 DESC, 6 DESC

-- 22.  User Segmentation: If you were to cluster users into three personas—"Digital Nomads," "Stressed Power Users," 
-- and "Balanced Users"—what would the boundaries for each group be? 

SELECT
	CASE 
	WHEN daily_phone_hours > 6 AND work_productivity_score > 7 THEN 'Digital Nomads'
	WHEN daily_phone_hours > 6 AND stress_level > 6 THEN 'Stressed Power Users'
	WHEN daily_phone_hours < 4 AND stress_level < 5 AND sleep_hours > 6 THEN 'Balanced User'
	ELSE 'Others'
	END AS user_segmentation,
	COUNT(*)
FROM phoneanal
GROUP BY 1

--23. Outlier Detection: Find users whose weekend_screen_time_hours is more than standard deviations plus the mean. 
-- Are these mostly students or professionals?
WITH table1
AS
(
SELECT
	ROUND(STDDEV(weekend_screen_time_hours)::numeric,2) AS deviation,
	ROUND(AVG(weekend_screen_time_hours)::numeric,2) AS avg_weekend
FROM phoneanal
)
SELECT
	occupation,
	COUNT(outlier_segmentation)
FROM
(
SELECT
	user_id,
	occupation,
	weekend_screen_time_hours,
	CASE
	WHEN weekend_screen_time_hours > (deviation + avg_weekend) THEN 'High Outlier'
	WHEN weekend_screen_time_hours < (deviation + avg_weekend) THEN 'Lowe Outlier'
	ELSE 'Unknown'
	END AS outlier_segmentation
FROM phoneanal,table1
)
GROUP BY 1
--they are the same.

-- 24.  Caffeine Compensation: Perform a group-by analysis to see if users with high stress_level and low sleep_hours have 
-- a higher-than-average caffeine_intake_cups.
-- avg stress = 5
-- avg sleep = 6
SELECT
	segmentation,
	AVG(caffeine_intake_cups)
FROM
(
SELECT
	CASE
	WHEN stress_level > 5 AND sleep_hours < 6 THEN 'Elligible'
	ELSE 'Non_Elligible'
	END AS segmentation,
	caffeine_intake_cups
FROM phoneanal
)
GROUP BY 1

