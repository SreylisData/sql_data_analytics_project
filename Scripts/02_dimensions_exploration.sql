/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Explore customers by country --

SELECT DISTINCT country 
FROM gold.dim_customers
ORDER by country;

-- Explore list of unique categories, subcategories, and products --

SELECT DISTINCT 
	category, 
	subcategory, 
	product_name 
FROM gold.dim_products
ORDER by category, subcategory, product_name;
