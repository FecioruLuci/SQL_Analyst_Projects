
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