/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATE_PART(), DATE_TRUNC()
    - Aggregate Functions: SUM(), COUNT()
===============================================================================
*/

-- Analyse sales performance over time
-- DATE_PART() --

SELECT
DATE_PART('year', order_date) AS order_year,
DATE_PART('month', order_date) AS order_month,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

-- DATE_TRUNC() --

SELECT
DATE_TRUNC('month', order_date)::DATE AS order_date,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP By DATE_TRUNC('month', order_date)
ORDER By DATE_TRUNC('month', order_date);
