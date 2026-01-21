DROP TABLE IF EXISTS uber_rides
CREATE TABLE uber_rides(
	date_created	TIMESTAMP,	
	time_created	TIME,
	booking_id	VARCHAR(50),
	booking_status	VARCHAR(50),
	customer_id	VARCHAR(50),
	vehicle_type	VARCHAR(50),
	pickup_location	VARCHAR(50),
	drop_location	VARCHAR(50),
	avg_vtat	FLOAT,
	avg_ctat	FLOAT,
	cancelled_rides_by_customer	INT,	
	reason_for_cancelling_by_customer	VARCHAR(50),	
	cancelled_rides_by_driver	INT,
	driver_cancellation_reason	VARCHAR(50),
	incomplete_rides	INT,	
	incomplete_rides_reason	VARCHAR(50),
	booking_value	INT,
	ride_distance	FLOAT,
	driver_ratings	FLOAT,
	customer_rating	FLOAT,
	payment_method	VARCHAR(50)

)
-- 1.Write a query to count the total number of bookings for each booking_status.
SELECT
	COUNT(*),
	booking_status
FROM uber_rides
GROUP BY booking_status

--  2.Retrieve all booking_ids where the booking_value is greater than 500.

SELECT
	booking_id,
	booking_value
FROM uber_rides
WHERE booking_value > 500
ORDER BY 2 DESC

-- 3.List all unique pickup_location names present in the database.
SELECT
	DISTINCT pickup_location
FROM uber_rides

-- 4.Find all rides completed using a 'Prime Sedan' as the vehicle_type.

SELECT
	*
FROM uber_rides
WHERE vehicle_type = 'Premier Sedan'
	AND
	booking_status = 'Completed'

-- 5.Calculate the average customer_rating for all completed rides.

SELECT
	ROUND(AVG(customer_rating)::numeric,2) as customer_average
FROM uber_rides
WHERE booking_status = 'Completed'

-- 6.Retrieve all bookings created on the date '2024-01-15'.

SELECT *
FROM uber_rides
WHERE date_created = '2024-01-15'

-- 7.Find all customers whose pickup_location starts with the letter 'A' using LIKE.

SELECT
	customer_id,
	pickup_location
FROM uber_rides
WHERE pickup_location LIKE 'A%'
ORDER BY 1

--  8.Select the top 5 highest booking_value entries, ordered from largest to smallest.
SELECT *
FROM
(
SELECT
	customer_id,
	booking_value,
	RANK() OVER (ORDER BY booking_value DESC)
FROM uber_rides
)
WHERE rank <= 5

-- 9.Count how many rides have a NULL value in the driver_cancellation_reason column.

SELECT
	COUNT(*) as good_rides
FROM uber_rides
WHERE driver_cancellation_reason IS NULL

-- 10.Identify the most used payment_method using LIMIT 1.

SELECT
	COUNT(payment_method) as nr_of_payments,
	payment_method
FROM uber_rides
GROUP BY 2
ORDER BY 1 DESC
LIMIT 1

-- 11.Use EXTRACT(HOUR FROM time_created) to find which hour of the day has the most bookings.

SELECT
	COUNT(EXTRACT(HOUR FROM time_created)) as nr_of_bookings,
	EXTRACT(HOUR FROM time_created)
FROM uber_rides
GROUP BY EXTRACT(HOUR FROM time_created)
ORDER BY 1 DESC

-- 12.Calculate the percentage of rides cancelled by customers versus the total number of bookings.
with table1
AS
(
SELECT
	COUNT(cancelled_rides_by_customer) as nr_of_decline
FROM uber_rides
WHERE cancelled_rides_by_customer = 1
)

SELECT
	ROUND(nr_of_decline / (SELECT COUNT(*) FROM uber_rides)::numeric * 100,2) as percentage
FROM table1

-- 13.Find customer_ids who have made more than 2 bookings.

SELECT
	booking_id,
	COUNT(booking_id)
FROM uber_rides
GROUP BY 1
HAVING COUNT(booking_id) > 2
ORDER BY 2 DESC

-- 14.List each vehicle_type and its total revenue, but only for types that generated more than 10000000 in total.

SELECT
	vehicle_type,
	SUM(booking_value) as total_revenue
FROM uber_rides
GROUP BY 1
HAVING SUM(booking_value) > 10000000
ORDER BY 2 DESC

-- 15.Create a column value_category using a CASE statement (e.g., >500 is 'High', else 'Low').

SELECT
	*,
	CASE
	WHEN booking_value > 500 THEN 'High'
	WHEN booking_value > 0 AND booking_value < 500 THEN 'Low'
	ELSE 'Cancelled'
	END AS value_category
FROM uber_rides

-- 16.Calculate the average ride_distance for each vehicle_type.

SELECT
	vehicle_type,
	ROUND(AVG(ride_distance)::numeric,2) as avg_distance_per_vehicle
FROM uber_rides
GROUP BY 1

-- 17.(Assuming a separate Customer table) Join the bookings with customers to find the names of people who used 'Cash' payment.

SELECT
	booking_id,
	customer_name
FROM uber_rides as u
INNER JOIN customers as c
ON u.customer_id = c.customer_id
WHERE payment = 'Cash'

-- 18.For all cancelled_rides_by_driver, list the top 3 most common driver_cancellation_reason.

SELECT 
	driver_cancellation_reason,
	COUNT(driver_cancellation_reason)
FROM uber_rides
WHERE cancelled_rides_by_driver = 1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3

-- 19.Group the total booking_value by month.

SELECT 
	SUM(booking_value) AS total_booking_value,
	EXTRACT(MONTH FROM date_created) AS monthh
FROM uber_rides
GROUP BY 2
ORDER BY 2

--20.Find the difference between customer_rating and driver_ratings for each booking.

SELECT
	booking_id,
	customer_rating,
	driver_ratings,
	ROUND(ABS(customer_rating - driver_ratings)::numeric,2) as difference
FROM uber_rides
ORDER BY 1 ASC

-- 21.Rank customers within each pickup_location based on their total booking_value.

SELECT
	customer_id,
	booking_id,
	pickup_location,
	booking_value,
	RANK() OVER(PARTITION BY pickup_location ORDER BY booking_value DESC) AS customer_ranking
FROM uber_rides

-- 22.Calculate a 7-day rolling average of the daily total booking_value.
with total
AS
(
SELECT
	date_created,
	SUM(booking_value) as suma
FROM uber_rides
GROUP BY 1
)

SELECT
	date_created,
	suma,
	ROUND(AVG(suma) OVER(ORDER BY date_created ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)::numeric,2) AS averagee
FROM total
ORDER BY date_created

-- 23.Using a CTE, find the average time difference between a customer's first and second booking.
with firstt
AS
(
SELECT
	customer_id,
	date_created,
	MIN(date_created) AS first_order
FROM uber_rides
GROUP BY 1,2
)

SELECT
	customer_id,
	first_order,
	MAX(date_created) AS last_order,
	MAX(date_created) - first_order
FROM firstt
GROUP BY 1
