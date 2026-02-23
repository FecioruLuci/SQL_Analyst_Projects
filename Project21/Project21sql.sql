DROP TABLE IF EXISTS books
CREATE TABLE books(
Book_ID	INT PRIMARY KEY,
Title	VARCHAR(75),
Author	VARCHAR(50),
Genre	VARCHAR(25),
Published_Year	INT,
Price	FLOAT,
Stock	INT
)
DROP TABLE IF EXISTS customers
CREATE TABLE customers(
Customer_ID	INT PRIMARY KEY,
Name	VARCHAR(25),
Email	VARCHAR(50),
Phone	BIGINT,
City	VARCHAR(25),
Country	VARCHAR(75)
)

DROP TABLE IF EXISTS orders
CREATE TABLE orders(
Order_ID	INT PRIMARY KEY,	
Customer_ID	INT,
Book_ID	INT,
Order_Date	DATE,
Quantity	INT,
Total_Amount	FLOAT
)



-- 1.Retreive al books in the fiction genre
SELECT *
FROM books
WHERE genre = 'Fiction'

-- 2.Find books published after the year 1950

SELECT *
fROM books
WHERE published_year > 1950

-- 3.List all customers from the Canada

SELECT *
FROM customers
WHERE country = 'Canada'

-- 4.Show orders placed in November 2023

SELECT *
FROM orders
WHERE order_date >= '2023-11-01' AND order_date <= '2023-11-30'
ORDER BY order_date ASC

-- 5.Retrieve the total stock of books available

SELECT
	SUM(stock) AS  total_stock
FROM books

-- 6.Find the details of the most expensive book

SELECT
	*
FROM books
ORDER BY price DESC
LIMIT 1

-- 7.Show all customers who ordered more than 1 quantity of a book

SELECT
	customer_id,
	quantity
FROM orders
WHERE quantity > 1

-- 8. Retrieve all orders where the total amount exceeds $20

SELECT
	order_id,
	total_amount
FROM orders
WHERE total_amount > 20

-- 9. List all genres available in the Books table

SELECT
	DISTINCT genre
FROM books

-- 10.Find the book with the lowest stock
SELECT
	*
FROM
(
SELECT
	*,
	RANK() OVER(ORDER BY stock ASC) AS ranking
FROM books
)
WHERE ranking = 1

-- 11. Calculate the total revenue generated from all orders

SELECT
	ROUND(SUM(total_amount)::numeric,2) AS total_revenue
FROM orders

-- 12.Retrieve the total number of books sold for each genre

SELECT
	genre,
	SUM(quantity) AS total_amount_sold
FROM books as b
LEFT JOIN orders as o
ON b.book_id = o.book_id
GROUP BY 1

-- 13.Find the average price of books in the "Fantasy" genre

SELECT
	genre,
	ROUND(AVG(price)::numeric,2) AS avg_price
FROM books
WHERE genre = 'Fantasy'
GROUP BY 1

-- 14.List customers who have placed at least 2 orders
WITH table1
AS
(
SELECT
	customer_id,
	COUNT(customer_id) AS number_of_orders
FROm orders
GROUP BY 1
HAVING COUNT(customer_id) > 1
)

SELECT
	t.customer_id,
	t.number_of_orders,
	o.order_date
FROM orders AS o
INNER JOIN table1 AS t
ON o.customer_id = t.customer_id

-- 15.Find the most frequently ordered book

SELECT 
	o.book_id,
	b.title,
	b.author,
	b.genre,
	SUM(quantity)
FROM orders AS o
LEFT JOIN books AS b
ON o.book_id = b.book_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC

-- 16.Show the top 3 most expensive books of 'Fantasy' Genre

SELECT
	*
FROM books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3

-- 17.Retrieve the total quantity of books sold by each author

SELECT
	author,
	SUM(o.quantity) AS total_quantity
FROM books AS b
LEFT JOIN orders AS o
ON b.book_id = o.book_id
GROUP BY 1

-- 18.List the cities where customers who spent over $30 are located

SELECT
	o.customer_id,
	o.total_amount,
	c.city
FROM orders AS o
LEFT JOIN customers AS c
ON o.customer_id = c.customer_id
WHERE total_amount > 30

-- 19.Find the customer who spent the most on orders

SELECT
	c.customer_id,
	c.name,
	c.email,
	c.phone,
	o.total_amount
FROM customers AS c
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id
WHERE total_amount IS NOT NULL
ORDER BY 5 DESC
LIMIT 1

-- 20.Calculate the stock remaining after fulfilling all orders
WITH table1
AS
(
SELECT 
	SUM(quantity) AS total_bought
FROM orders
)

SELECT
	SUM(stock)::numeric - total_bought AS total_stock_remaining
FROM books,table1
GROUP BY total_bought