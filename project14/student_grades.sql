DROP TABLE IF EXISTS grades
CREATE TABLE grades (
student_id	VARCHAR(10) PRIMARY KEY,
hours_studied	FLOAT,
sleep_hours	FLOAT,
attendance_percent	FLOAT,	
previous_scores	INT,
exam_score	FLOAT
)

SELECT *
FROM grades

-- Retrieve all students who scored above 80 on the exam

SELECT 
	student_id,
	exam_score
FROM grades
WHERE exam_score > 80

-- What is the total number of students in the dataset?

SELECT
	COUNT(DISTINCT student_id) as nr_of_students
FROM grades

-- Show students who slept less than 6 hours per night

SELECT
	student_id,
	sleep_hours
FROM grades
WHERE sleep_hours < 6

-- What is the average exam score across all students?

SELECT
	AVG(exam_score) AS avg_score
FROM grades

-- Display the top 5 students with the highest previous scores

SELECT
	student_id,
	previous_scores
FROM grades
ORDER BY 2 DESC
LIMIT 5

-- Find students with perfect attendance (100%)

SELECT
	student_id,
	attendance_percent
FROM grades
WHERE attendance_percent = 100

-- What is the range of study hours among all students?

SELECT
	MIN(hours_studied) AS minimum_hours,
	MAX(hours_studied) AS maximum_hours
FROM grades

-- How does study time relate to exam performance? Group students by study hours categories 
-- (Low: <3h, Medium: 3-6h, High: >6h) and calculate their average exam scores
with table1
AS
(
SELECT
	student_id,
	hours_studied,
	exam_score,
	CASE
	WHEN hours_studied < 3 THEN 'Low'
	WHEN hours_studied BETWEEN 3 AND 6 THEN 'Medium'
	ELSE 'High'
	END AS category
FROM grades
)

SELECT 
	*,
	ROUND(AVG(exam_score) OVER(partition by category)::numeric,1)
FROM table1

--Which students show significant performance inconsistency? 
--Identify students where the difference between their previous scores and exam scores is greater than 15 points

SELECT
	student_id,
	exam_score,
	previous_scores
FROM grades
WHERE ABS(previous_scores - exam_score) > 15

-- What is the impact of attendance on exam results? Categorize students by attendance levels and calculate average exam scores for each category
with table1
AS
(
SELECT
	student_id,
	attendance_percent,
	exam_score,
	CASE
	WHEN attendance_percent <= 30 THEN 'Low'
	WHEN attendance_percent > 30 AND attendance_percent <= 70 THEN 'Medium'
	ELSE 'High'
	END AS segmentation
FROM grades
)

SELECT
	segmentation,
	AVG(exam_score) AS avg_score
FROM table1
GROUP BY 1

-- Identify at-risk students (exam score below 50) and show their study habits and attendance patterns

SELECT
	student_Id,
	hours_studied,
	sleep_hours,
	attendance_percent,
	exam_score
FROM grades
WHERE exam_score < 50

-- Is there a correlation between sleep and academic performance? Group students by sleep categories and compare their average exam scores and study hours
with table1
AS
(
SELECT
	student_id,
	sleep_hours,
	exam_score,
	CASE
	WHEN sleep_hours <= 5 THEN 'LowSleep'
	WHEN sleep_hours > 5 AND sleep_hours <= 7 THEN 'NormalSleep'
	ELSE 'LotsOfSleep'
	END AS sleepcategory
FROM grades
)

SELECT 
	sleepcategory,
	AVG(exam_score) AS avg_score
FROM table1
GROUP BY 1

-- What percentage of students studied more than 4 hours but still scored below average on the exam?
SELECT 
	ROUND(COUNT(*) / (SELECT COUNT(*) FROM grades)::numeric * 100) AS percentage
FROM(
SELECT
	student_id,
	hours_studied,
	exam_score
FROM grades
WHERE hours_studied > 4
)
WHERE exam_score < (SELECT AVG(exam_score) FROM grades)

-- Compare the average exam scores between students who sleep more than 7 hours versus those who sleep less
with table1
AS
(
SELECT
	ROUND(AVG(exam_score)::numeric,1) as avg_score_less
FROM grades
WHERE sleep_hours < 7
),
table2
AS
(
SELECT
	ROUND(AVG(exam_score)::numeric,1) as avg_score_more
FROm grades
WHERE sleep_hours > 7
)

SELECT
	t1.avg_score_less,
	t2.avg_score_more
FROM table1 as t1
CROSS JOIN table2 as t2

-- Perform cluster analysis by dividing students into 3 equal performance tiers based on exam scores and compare their study habits, 
-- sleep patterns, and attendance across tiers
with table1
AS
(
SELECT
	student_id,
	hours_studied,
	sleep_hours,
	attendance_percent,
	exam_score,
	NTILE (3) OVER(ORDER BY exam_score DESC) ranking
FROM grades
)

SELECT
	COUNT(*),
	ROUND(AVG(hours_studied)::numeric,1) AS avg_hours,
	ROUND(AVG(sleep_hours)::numeric,1) AS avg_sleep,
	ROUND(AVG(attendance_percent)::numeric,1) AS avg_att,
	ROUND(AVG(exam_score)::numeric,1) AS avg_score
FROM table1
GROUP BY ranking

-- Which factor has the strongest correlation with exam performance? Calculate correlation coefficients between all numerical variables and exam score

SELECT
	ROUND(CORR(hours_studied, exam_score)::numeric,2) AS hour_corr,
	ROUND(CORR(sleep_hours, exam_score)::numeric,2) AS sleep_corr,
	ROUND(CORR(attendance_percent, exam_score)::numeric,2) AS attend_corr,
	ROUND(CORR(previous_scores, exam_score)::numeric,2) AS prevscore_corr
FROM grades

-- Identify statistical outliers in study habits - find students whose study hours are more than 2 standard deviations from the mean
with table1
AS
(
SELECT
	AVG(hours_studied) AS avg_sleep,
	STDDEV(hours_studied) AS standev
FROM grades
)

SELECT
	student_id,
	hours_studied,
	exam_score,
	hours_studied - avg_sleep AS diff_cu_avg,
	(hours_studied - avg_sleep) / standev AS abaterea_standard
FROM grades as g
CROSS JOIN table1 as t1
ORDER BY abaterea_standard DESC

-- Analyze student progress by calculating the percentage improvement or decline from previous scores to exam scores, and categorize the level of improvement

SELECT *
FROM grades