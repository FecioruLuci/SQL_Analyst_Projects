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

-- 1.	Is there a correlation between alcohol consumption and the presence of skin cancer?
SELECT
	ROUND(CORR(skin_cancer_int, alcohol_consumption)::numeric,2) as corelation
FROM
(
SELECT
	alcohol_consumption,
	CASE
	WHEN skin_cancer = 'Yes' THEN 1
	ELSE 0S
	END as skin_cancer_int
FROM covidd
)

-- 2.	What is the average BMI for people with heart disease vs. without?
WITH with_disease
AS
(
SELECT
	ROUND(AVG(bmi)::numeric,2) as avg_bmi_with
FROM covidd
WHERE heart_disease = 'Yes'
),
without_disease
AS
(
SELECT
	ROUND(AVG(bmi)::numeric,2) as avg_bmi_without
FROM covidd
WHERE heart_disease = 'No'
)

SELECT
	withd.avg_bmi_with,
	withoutd.avg_bmi_without
FROM with_disease as withd,without_disease as withoutd

-- 3.	How does green vegetable consumption vary by age category?

SELECT
	age_category,
	ROUND(AVG(green_vegetables_consumption)::numeric,2) as vary
FROM covidd
GROUP BY 1

-- 4.	What is the prevalence of arthritis in men vs. women?

SELECT
	sex,
	COUNT(*),
	SUM(CASE WHEN arthritis = 'Yes' THEN 1 ELSE 0 END) AS prevelance_yes,
	SUM(CASE WHEN arthritis = 'No' THEN 1 ELSE 0 END) AS prevelance_no,
	ROUND(SUM(CASE WHEN arthritis = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)::numeric,2) AS percentage
FROM covidd
GROUP BY 1
ORDER BY 1

-- 5.	Is there a difference in fried potato consumption between smokers and non-smokers?
with yes_smokers
AS
(
SELECT

	smoking_history,
	ROUND(AVG(friedpotato_consumption)::numeric,2) as fried_pot_cons_yes,
	ROUND(STDDEV(friedpotato_consumption)::numeric,2) AS deviation_yes
FROM covidd
WHERE smoking_history = 'Yes'
GROUP BY 1
),
no_smokers
AS
(
SELECT
	smoking_history,
	ROUND(AVG(friedpotato_consumption)::numeric,2) as fried_pot_cons_no,
	ROUND(STDDEV(friedpotato_consumption)::numeric,2) AS deviation_no
FROM covidd
WHERE smoking_history = 'No'
GROUP BY 1
)

SELECT * FROM yes_smokers
UNION ALL 
SELECT * FROM no_smokers

-- 6.	What is the relationship between the frequency of checkups and the presence of other types of cancer?

SELECT 
	checkup,
	COUNT(*),
	SUM(CASE WHEN other_cancer = 'Yes' THEN 1 ELSE 0 END) AS people_with_cancer,
	SUM(CASE WHEN other_cancer = 'No' THEN 1 ELSE 0 END) AS people_with_cancer,
	ROUND(SUM(CASE WHEN other_cancer = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)::numeric,2) AS with_cancer_percentage
FROM covidd
GROUP BY 1

-- 1.	What are the most important risk factors that predict diabetes in this dataset? 
with by_exercise
AS
(
SELECT
	diabetes,
	SUM(CASE WHEN exercise = 'Yes' THEN 1 ELSE 0 END) AS yes_exercise,
	SUM(CASE WHEN exercise = 'No' THEN 1 ELSE 0 END) AS no_exercise
FROM covidd
GROUP BY 1
),
by_depression
AS
(
SELECT
	diabetes,
	SUM(CASE WHEN depression = 'Yes' THEN 1 ELSE 0 END) AS yes_depression,
	SUM(CASE WHEN depression = 'No' THEN 1 ELSE 0 END) AS no_depression
FROM covidd
GROUP BY 1
)

SELECT
	be.diabetes,
	be.yes_exercise,
	be.no_exercise,
	bd.yes_depression,
	bd.no_depression
FROM by_exercise as be
JOIN by_depression as bd 
ON be.diabetes = bd.diabetes

-- 2.	Is there a non-linear relationship between age and the probability of having heart disease?

SELECT
	age_category,
	COUNT(*),
	SUM(CASE WHEN heart_disease = 'Yes' THEN 1 ELSE 0 END) AS disease_yes,
	SUM(CASE WHEN heart_disease = 'No' THEN 1 ELSE 0 END) AS disease_no,
	ROUND(SUM(CASE WHEN heart_disease = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS percentage_with_desease
FROM covidd
GROUP BY 1

-- 3.	What is the combined impact of fruit and green vegetable consumption on the risk of depression?

SELECT
	depression,
	AVG(fruit_consumption),
	AVG(green_vegetables_consumption)
FROM covidd

-- people with no depresion tend to eat more fruits and vegetables
GROUP BY 1

