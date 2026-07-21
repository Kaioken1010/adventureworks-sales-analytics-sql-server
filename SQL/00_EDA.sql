/*
===============================================================================
Exploratory Data Analysis (EDA)
===============================================================================

Script Purpose:
    Perform initial exploration of the AdventureWorksDW2025 dataset to
    understand table structures, data quality, relationships, and business
    attributes before building the analytical model.

===============================================================================
*/

SELECT TOP 10 
	*
FROM FactInternetSales;
--------------------------------
SELECT TOP 10 
	*
FROM FactResellerSales;
--------------------------------
SELECT top 10
	*
FROM DimCustomer
--------------------------------
SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FactInternetSales';