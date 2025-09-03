/*
===============================================================================
Date Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATE_PART(), EXTRACT()
===============================================================================
*/

-- Find the date of the first and last order --
-- How many years of sales are available --

SELECT 
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATE_PART('year', '2014-01-28'::date) - DATE_PART('year', '2010-12-29'::date)
	AS order_range_years
FROM gold.fact_sales;

-- Find the yongest and oldest customers based on birthdate --

SELECT
	MIN(birthdate) AS oldest_birthdate,
	MAX(birthdate) AS youngest_birthdate,
	EXTRACT(YEAR FROM age(current_date, MAX(birthdate))) AS youngest_age,
	EXTRACT(YEAR FROM age(current_date, MIN(birthdate))) AS oldest_age
FROM gold.dim_customers;
