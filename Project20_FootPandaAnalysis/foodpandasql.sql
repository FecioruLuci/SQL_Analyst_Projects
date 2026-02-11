DROP TABLE IF EXISTS foodpanda
CREATE TABLE foodpanda(
customer_id	VARCHAR(15),
gender	VARCHAR(15),
age	VARCHAR(25),
city	VARCHAR(25),
signup_date	DATE,
order_id	VARCHAR(25),
order_date	DATE,
restaurant_name	VARCHAR(25),
dish_name	VARCHAR(25),
category	VARCHAR(25),
quantity	INT,
price	FLOAT,
payment_method	VARCHAR(25),	
order_frequency	INT,
last_order_date	DATE,
loyalty_points	INT,
churned	VARCHAR(25),
rating	INT,
rating_date	DATE,
delivery_status	VARCHAR(25)
)

SELECT *
FROM foodpanda