
## Overview

This project involves designing and querying a relational database for a bookstore. The database consists of three tables — Books, Customers, and Orders — and includes 20 SQL queries that cover a wide range of analysis scenarios.

## Database Schema

The database is built around three core tables:
Books — stores information about each book, including title, author, genre, publication year, price, and available stock.
Customers — contains customer details such as name, email, phone number, city, and country.
Orders — records each transaction, linking customers to books with details like order date, quantity purchased, and total amount spent.


## Queries & Analysis

## Basic Filtering & Retrieval
The first set of queries focuses on simple data retrieval using WHERE clauses. This includes filtering books by genre (Fiction, Fantasy), finding books published after a certain year, listing customers from a specific country (Canada), and showing orders placed within a specific time period (November 2023).

## Aggregations & Summary Statistics
Several queries calculate summary metrics across the dataset. These include the total stock of all books available, total revenue generated from all orders, and the average price of books within a specific genre. The SUM(), AVG(), and ROUND() functions are used extensively here.

## Ranking & Extremes
To find specific records like the most expensive book, the book with the lowest stock, or the top 3 most expensive Fantasy books, the project uses both ORDER BY with LIMIT and window functions (RANK() OVER()), showcasing two different approaches to the same type of problem.

## JOIN Operations
A large portion of the queries involve joining multiple tables to enrich the data. LEFT JOIN is used as the primary join type to ensure all records from the primary table are retained even when there's no match — for example, showing all authors and their total sales even if some books haven't been ordered yet. INNER JOIN is used when only matching records are relevant.

## CTEs (Common Table Expressions)
Two queries make use of CTEs (WITH clause) to break down complex logic into readable steps. One identifies customers who placed at least 2 orders by first aggregating order counts and then joining back to the orders table to retrieve additional details. The other calculates remaining stock by subtracting total quantities ordered from total book stock, using a CROSS JOIN between the books table and the aggregated CTE.

Key SQL Concepts Used

- **DDL: CREATE TABLE, DROP TABLE IF EXISTS
- **Filtering: WHERE, HAVING
- **Aggregation: SUM(), COUNT(), AVG(), ROUND()
- **Joins: LEFT JOIN, INNER JOIN, CROSS JOIN
- **Window Functions: RANK() OVER()
- **CTEs: WITH ... AS
- **Sorting & Limiting: ORDER BY, LIMIT
- **Type casting: ::numeric
- **Deduplication: DISTINCT

## This SQL analysis provides a comprehensive foundation for customer analytics, restaurant performance monitoring, and business decision-making for Foodpanda.

## 🧰 Tech Stack

   SQL (PostgreSQL / MySQL compatible)
   Python (Data Transformation)

## 📫 Connect with Me

   LinkedIn: [Connect with me professionally](https://www.linkedin.com/in/birsanlucian1/)
   
   E-Mail: birsan.lucian04@gmail.com







