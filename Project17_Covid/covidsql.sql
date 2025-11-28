DROP TABLE IF EXISTS covidd
CREATE TABLE covidd (
general_health	VARCHAR(15),
checkup	VARCHAR(25),
exercise	VARCHAR(15),
heart_disease	VARCHAR(15),
skin_cancer	VARCHAR(15),
other_cancer	VARCHAR(15),
depression	VARCHAR(15),
diabetes	VARCHAR(15),
arthritis	VARCHAR(15),
sex	VARCHAR(15),
age_category	VARCHAR(15),
heightcm	INT,
weightkg	FLOAT,
bmi	FLOAT,
smoking_history	VARCHAR(15),	
alcohol_consumption	INT,
fruit_consumption	INT,
green_vegetables_consumption	INT,	
friedpotato_consumption	INT
)


SELECT *
FROM covidd


-- 1.	What is the total number of people in the dataset?

SELECT
	COUNT(*)
FROM covidd

-- 2.	What is the average age of people in the dataset? (using age_category)

SELECT
	DISTINCT age_category
FROM covidd
ORDER BY 1 DESC


SELECT
	ROUND(AVG(age)::numeric) as avg_age
	FROM
(
SELECT
	CASE
	WHEN age_category = '70-74' THEN 74
	WHEN age_category = '75-79' THEN 79
	WHEN age_category = '60-64' THEN 64
	WHEN age_category = '65-69' THEN 69
	WHEN age_category = '55-59' THEN 59
	WHEN age_category = '50-54' THEN 54
	WHEN age_category = '45-49' THEN 49
	WHEN age_category = '40-44' THEN 44
	WHEN age_category = '35-39' THEN 39
	WHEN age_category = '30-34' THEN 34
	WHEN age_category = '25-29' THEN 29
	WHEN age_category = '18-24' THEN 24
	ELSE 80
	END AS age
FROM covidd
)

-- 3.	How many people have diabetes?


SELECT
	COUNT(*)
FROM covidd
WHERE diabetes = 'Yes'

-- 4.	What is the ratio between men and women?

SELECT
	sex,
	COUNT(*)
FROM covidd
GROUP BY 1

-- 5.	What is the average BMI of people in the dataset?

SELECT 
	ROUND(AVG(bmi)::numeric,2) as bmi_avg
FROM covidd

-- 6.	How many people have a history of smoking?

SELECT
	COUNT(*)
FROM covidd
WHERE smoking_history = 'Yes'

-- 7.	What is the average daily fruit consumption?

SELECT
	ROUND(AVG(fruit_consumption)::numeric,2) as fruit_consum_avg
FROM covidd

-- 8.	How many people exercise regularly?

SELECT 
	COUNT(*)
FROM covidd
WHERE exercise = 'Yes'

-- 9.	What is the rate of depression among people with diabetes vs. without diabetes?
WITH
table1
AS
(
SELECT
	ROUND(100 * COUNT(*)::numeric / (SELECT COUNT(*) FROM covidd WHERE diabetes = 'Yes'),2) as with_diabetes
FROM covidd
WHERE diabetes = 'Yes'
	AND depression = 'Yes'
),

table2
AS
(
SELECT
	ROUND(100 * COUNT(*)::numeric / (SELECT COUNT(*) FROM covidd WHERE diabetes = 'No'),2) as without_diabetes
FROM covidd
WHERE diabetes = 'No'
	AND depression = 'Yes'
)

SELECT
	table1.with_diabetes,
	table2.without_diabetes
FROM table1,table2