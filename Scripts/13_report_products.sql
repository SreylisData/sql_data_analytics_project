/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
	2. Segments products by revenue to identify High-Performers, Mid-Range, or Low_Performers.
    3. Aggregates product-level metrics:
	   - total orders
	   - total sales
	   - total quantity sold
	   - total customers (UNIQUE)
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order revenue (AOR)
		- average monthly revenue
===============================================================================
*/

CREATE VIEW gold.report_products AS

WITH base_query AS (
-- 1. Base quary: retrieves core columns from fact_sales and dim_products.
	SELECT
		f.order_number,
		f.order_date,
		f.customer_key,
		f.sales_amount,
		f.quantity,
		p.product_key,
		p.product_name,
		p.category,
		p.subcategory,
		p.cost 
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p 
		ON p.product_key = f.product_key
	WHERE f.order_date IS NOT NULL  
),
product_aggregation AS (
	SELECT
		product_key,
		product_name,
		category,
		subcategory,
		cost,
		EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) +
		   (EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12) AS lifespan,
		MAX(order_date) AS last_sale_date,
		COUNT(DISTINCT order_number) AS total_orders,
		COUNT(DISTINCT customer_key) AS total_customers,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		SUM(sales_amount) / SUM(quantity) AS avg_selling_price
	FROM base_query 
	GROUP BY 
		product_key,
		product_name,
		category,
		subcategory,
		cost
)
	SELECT
		product_key,
		product_name,
		category,
		subcategory,
		cost,
		last_sale_date,
		EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_sale_date)) * 12 +
	    EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_sale_date)) AS recency_in_months,
		CASE
			WHEN total_sales > 50000 THEN 'High-Performer'
			WHEN total_sales >= 10000 THEN 'Mid-Range'
			ELSE 'Low-Performer'
		END AS product_segment,
		lifespan,
		total_orders,
		total_sales,
		total_quantity,
		total_customers,
		avg_selling_price,
		-- Average Order Revenue (AOR)
		CASE
			WHEN total_orders = 0 THEN 0
			ELSE total_sales / total_orders
		END AS avg_order_revenue,
		-- Average Monthly Revenue
		CASE
			WHEN lifespan = 0 THEN total_sales
			ELSE total_sales / lifespan
		END::INT AS avg_monthly_revenue
	FROM product_aggregation; 
	
		
