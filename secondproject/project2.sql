-- create database

CREATE DATABASE secondproject;

-- creating branch table

DROP TABLE IF EXISTS branch;
CREATE TABLE branch(
	branch_id VARCHAR(10) PRIMARY KEY,
    manager_id	VARCHAR(10),
    branch_address	VARCHAR(15),
    contact_no	VARCHAR(15)
);
-- used =MAX(LEN(branch_adress)) in excel to determinate the maximum number of characters to put into varchar

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
	emp_id	VARCHAR(15) PRIMARY KEY,
	emp_name	VARCHAR(25),	
	position	VARCHAR(15),
	salary	INT,
    branch_id VARCHAR(25)
);

DROP TABLE IF EXISTS books;
CREATE TABLE books(
	isbn	VARCHAR(20) PRIMARY KEY,
	book_title	VARCHAR(75),
	category	VARCHAR(25),
	rental_price	FLOAT,
	status	VARCHAR(15),
	author	VARCHAR(25),
	publisher	VARCHAR(50)
);

DROP TABLE IF EXISTS members;
CREATE TABLE members(
	member_id	VARCHAR(15) PRIMARY KEY,
	member_name	VARCHAR(15),
	member_address	VARCHAR(15),
	reg_date	DATE
);

DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
	issued_id	VARCHAR(15) PRIMARY KEY,
	issued_member_id	VARCHAR(15),
	issued_book_name	VARCHAR(75),
	issued_date	DATE,
	issued_book_isbn	VARCHAR(25),	
	issued_emp_id	VARCHAR(15)
);

DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status(
	return_id	VARCHAR(15) PRIMARY KEY,
	issued_id	VARCHAR(15),
	return_book_name	VARCHAR(30),
	return_date	DATE,
	return_book_isbn	VARCHAR(30)
);

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issues_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);


-- Project Tasks

-- Q1 -- Create a new book record -- "978-1-60129-456-2", "To Kill a Mockingbird", "Classic", 6.00, "yes", "Harper Lee", "J.B . Lippingcott & Co."

SELECT *
FROM books;

INSERT INTO books(isbn,book_title,category,rental_price,status,author,publisher)
VALUES 
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B . Lippingcott & Co.');

SELECT *
FROM books
WHERE isbn = '978-1-60129-456-2';
-- checked and it indeed insert those values into books dateset

-- Q2 -- Update an Existing Member's Address

SELECT *
FROM members;

UPDATE members
SET member_address = "Str. Hello"
WHERE member_id = "C101";
-- checked and updated the address

-- Q3 -- Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT *
FROM issued_status
WHERE issued_id = "IS121";
-- checked and it's there

DELETE FROM issued_status
WHERE issued_id = "IS121";
-- checked and it got removed




