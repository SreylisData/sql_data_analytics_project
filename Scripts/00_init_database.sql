/*
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' and a schema called gold. 
=============================================================
*/

-- Create the 'DataWarehouseAnalytics' database -- 

CREATE DATABASE DataWarehouseAnalytics;

-- Create schema -- 

CREATE SCHEMA gold;

-- Create tables -- 

CREATE TABLE gold.dim_customers(
	customer_key INT,
	customer_id INT,
	customer_number VARCHAR(50),
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	country VARCHAR(50),
	marital_status VARCHAR(50),
	gender VARCHAR(50),
	birthdate DATE,
	create_date DATE
);

CREATE TABLE gold.dim_products(
	product_key INT,
	product_id INT,
	product_number VARCHAR(50),
	product_name VARCHAR(50),
	category_id VARCHAR(50),
	category VARCHAR(50),
	subcategory VARCHAR(50),
	maintenance VARCHAR(50),
	cost iNT,
	product_line VARCHAR(50),
	start_date DATE 
);

CREATE TABLE gold.fact_sales(
	order_number VARCHAR(50),
	product_key INT,
	customer_key INT,
	order_date DATE,
	shipping_date DATE,
	due_date DATE,
	sales_amount INT,
	quantity INT,
	price INT 
);

-- Insert datas into tables --

TRUNCATE TABLE gold.dim_customers;

COPY gold.dim_customers 
(customer_key, customer_id, customer_number, first_name, last_name, country, marital_status, gender, birthdate, create_date) 
FROM '/private/tmp/gold.dim_customers.csv' 
WITH (FORMAT CSV, HEADER TRUE);

TRUNCATE TABLE gold.dim_products;

COPY gold.dim_products 
(product_key, product_id, product_number, product_name, category_id, category, subcategory, maintenance, cost, product_line, start_date)
FROM '/private/tmp/gold.dim_products.csv' 
WITH (FORMAT CSV, HEADER TRUE);

TRUNCATE TABLE gold.fact_sales;

COPY gold.fact_sales 
(order_number, product_key, customer_key, order_date, shipping_date, due_date, sales_amount, quantity, price) 
FROM '/private/tmp/gold.fact_sales.csv' 
WITH (FORMAT CSV, HEADER TRUE);
