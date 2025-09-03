/*
===============================================================================
Database Exploration
===============================================================================
Script Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- Explore all objects in the database --

SELECT * 
FROM information_schema.tables; 

-- Explore all columns in the database --

SELECT * 
FROM information_schema.columns 
WHERE table_name = 'dim_customers';

