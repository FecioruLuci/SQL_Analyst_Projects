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