DROP TABLE IF EXISTS uber_rides
CREATE TABLE uber_rides(
	date_created	TIMESTAMP,	
	time_created	TIME,
	booking_id	VARCHAR(50),
	booking_status	VARCHAR(50),
	customer_id	VARC
	vehicle_type	
	pickup_location	
	drop_location	
	avg_vtat	
	avg_ctat	
	cancelled_rides_by_customer	
	reason_for_cancelling_by_customer	
	cancelled_rides_by_driver	
	driver_cancellation_reason	
	incomplete_rides	
	incomplete_rides_reason	
	booking_value	
	ride_distance	
	driver_ratings	
	customer_rating	payment_method

)
-- Write a query to count the total number of bookings for each booking_status.
SELECT
	COUNT(*),
	booking_status
FROM uber_rides
GROUP BY booking_status

--  Retrieve all booking_ids where the booking_value is greater than 500.

SELECT
	booking_id,
	booking_value
FROM uber_rides
WHERE booking_value > 500
ORDER BY 2 DESC

-- List all unique pickup_location names present in the database.
SELECT
	DISTINCT pickup_location
FROM uber_rides

-- Find all rides completed using a 'Prime Sedan' as the vehicle_type.

SELECT
	*
FROM uber_rides
WHERE vehicle_type = 'Premier Sedan'
	AND
	booking_status = 'Completed'

-- Calculate the average customer_rating for all completed rides.

SELECT
	ROUND(AVG(customer_rating)::numeric,2) as customer_average
FROM uber_rides
WHERE booking_status = 'Completed'

-- Retrieve all bookings created on the date '2024-01-15'.

SELECT *
FROM uber_rides
WHERE date_created = '2024-01-15'

-- Find all customers whose pickup_location starts with the letter 'A' using LIKE.

SELECT
	customer_id,
	pickup_location
FROM uber_rides
WHERE pickup_location LIKE 'A%'
ORDER BY 1

--  Select the top 5 highest booking_value entries, ordered from largest to smallest.
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

-- Count how many rides have a NULL value in the driver_cancellation_reason column.

SELECT
	COUNT(*) as good_rides
FROM uber_rides
WHERE driver_cancellation_reason IS NULL

-- Identify the most used payment_method using LIMIT 1.

SELECT
	COUNT(payment_method) as nr_of_payments,
	payment_method
FROM uber_rides
GROUP BY 2
ORDER BY 1 DESC
LIMIT 1
