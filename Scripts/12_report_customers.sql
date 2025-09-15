/*
===============================================================================
Customer Report
===============================================================================
Purpose: This report consolidates key customer metrics and behaviour. 

Key Highlights:
	1. Collect essential fields: name, age, and transaction details.
	2. Segments customers into meaningful categories (VIP, Regular, New) and age groups.
	3. Aggregate customer-level metrics:
	    - Total orders
	    - Total sales
	    - Total quantity purchased
	    - Total distinct products
	    - Customer lifespan (in months)
	4. Calculate customer KPIs:
	    - Recency (months since last order)
	    - Average order value (AOV)
	    - Average monthly spend
===============================================================================
*/

-- Create Report: gold.report_customers
CREATE VIEW gold.report_customers AS

WITH base_query AS (
/*---------------------------------------------------------------------------
	1) Base query: retrieve core columns from fact_sales and dim_customers
---------------------------------------------------------------------------*/
	SELECT
		f.order_number,
		f.product_key,  
		f.order_date,
		f.sales_amount,
		f.quantity,
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
		EXTRACT(YEAR FROM age(c.birthdate)) AS age
	FROM gold.fact_sales f 
	LEFT JOIN gold.dim_customers c 
		ON c.customer_key = f.customer_key
	WHERE f.order_date IS NOT NULL
), 
customer_aggregation AS (
/*---------------------------------------------------------------------------
	2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
	SELECT 
		customer_key,
		customer_number,
		customer_name,
		age,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS last_order_date,
		EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) +
			(EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12) AS lifespan
	FROM base_query
	GROUP BY
		customer_key,
		customer_number,
		customer_name,
		age
) 
/*---------------------------------------------------------------------------
	3) Final Query: Combine all customer results into one output
---------------------------------------------------------------------------*/
	SELECT
		customer_key,
		customer_number,
		customer_name,
		age, 
		CASE 
			WHEN age < 20 THEN 'Under 20'
			WHEN age BETWEEN 20 and 29 THEN '20-29'
			WHEN age BETWEEN 30 and 39 THEN '30-39'
			WHEN age BETWEEN 40 and 49 THEN '40-49'
			ELSE '50 and above'
		END age_group,
		CASE 
			WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
			WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
			ELSE 'New'
		END customer_segment,
		last_order_date,
		EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_order_date)) * 12 +
		    EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_order_date)) AS recency_in_months,
		total_orders,
		total_sales,
		total_quantity,
		total_products,
		lifespan,
		-- average order value (AOV)
		CASE 
			WHEN total_sales = 0 THEN 0
			ELSE total_sales / total_orders
		END AS avg_order_value,
		-- average monthly spend
		CASE 
			WHEN lifespan = 0 THEN total_sales
			ELSE total_sales / lifespan
		END::INT AS avg_monthly_spend
	FROM customer_aggregation;
