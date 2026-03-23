CREATE TABLE games(
img	VARCHAR(150),
title	VARCHAR(150),
console	VARCHAR(10),
genre	VARCHAR(20),
publisher	VARCHAR(50),
developer	VARCHAR(75),
critic_score	FLOAT,
total_sales	FLOAT,
na_sales	FLOAT,
jp_sales	FLOAT,
pal_sales	FLOAT,
other_sales	FLOAT,
release_date	DATE,
last_update	DATE
)

SELECT *
FROM games