/*
===============================================================================
Data Loading & Transformation
===============================================================================

Script Purpose:
    Extract data from AdventureWorksDW2025 and populate the analytical
    tables with cleaned and transformed data suitable for reporting.

Transformations Include:
    • Customer enrichment
    • Product categorization
    • Gender and marital status mapping
    • Geographic information
    • Product status handling
    • Sales fact preparation

===============================================================================
*/

CREATE OR ALTER PROCEDURE DataInsert AS

BEGIN
	DECLARE @StartTime DATETIME, @EndTime DATETIME
	
	BEGIN TRY
		/*=====================*/
		--NewFactInternetSales
		/*=====================*/
		
		PRINT('Truncating Table: NewFactInternetSales');
		TRUNCATE TABLE NewFactInternetSales;
		PRINT('Inserting Data Into: NewFactInternetSales');
		SET @StartTime = GETDATE()
		INSERT INTO NewFactInternetSales
		(
			ProductKey,
			OrderDateKey,
			CustomerKey,
			SalesOrderNumber,
			OrderQuantity,
			UnitPrice,
			ProductStandardCost ,
			TotalProductCost,
			SalesAmount,
			OrderDate,
			DueDate,
			ShipDate
		)
		SELECT 
			ProductKey,
			OrderDateKey,
			CustomerKey,
			SalesOrderNumber,
			OrderQuantity,
			CAST(UnitPrice as DECIMAL(19,4)) AS UnitPrice,
			CAST(ProductStandardCost as DECIMAL(19,4)) as ProductStandardCost,
			CAST(TotalProductCost as DECIMAL(19,4)) as TotalProductSales,
			CAST(SalesAmount as DECIMAL(19,4)) as SalesAmount,
			CAST(OrderDate as DATE) as OrderDate,
			CAST(DueDate as DATE) as DueDate,
			CAST(ShipDate as DATE) as ShipDate
		FROM FactInternetSales
		
		SET @EndTime = GETDATE()
		PRINT('Total time taken: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) as NVARCHAR));
		PRINT('------------------------------------------------------------------------------');

		/*=====================*/
		--NewDimCustomer
		/*=====================*/
		PRINT('Truncating Table: NewDimCustomer');
		TRUNCATE TABLE NewDimCustomer;
		PRINT('Inserting Data Into: NewDimCustomer');
		SET @StartTime = GETDATE()
		INSERT INTO NewDimCustomer
		(
			CustomerKey,
			GeographyKey,
			CustomerAlternateKey,
			FirstName,
			MiddleName,
			LastName,
			City,
			StateProvinceCode,
			StateProvinceName,
			CountryRegionCode,
			CountryRegionName,
			BirthDate,
			MaritalStatus,
			Gender,
			EmailAddress,
			YearlyIncome,
			DateFirstPurchase
		)

		SELECT
			dc.CustomerKey,
			dc.GeographyKey,
			dc.CustomerAlternateKey, 
			dc.FirstName,
			dc.MiddleName,
			dc.LastName,
			dg.City,
			dg.StateProvinceCode,
			dg.StateProvinceName,
			dg.CountryRegionCode,
			dg.EnglishCountryRegionName,
			dc.BirthDate,
			CASE	
				WHEN dc.MaritalStatus = 'S' THEN 'Single'
				ELSE 'Married'
			END as MaritalStatus,
			CASE
				WHEN dc.Gender = 'M' THEN 'Male'
				ELSE 'Female'
			END as Gender,
			dc.EmailAddress,
			dc.YearlyIncome,
			dc.DateFirstPurchase
		FROM DimCustomer dc
		LEFT JOIN DimGeography dg ON dc.GeographyKey = dg.GeographyKey
		SET @EndTime = GETDATE()
		PRINT('Time Taken: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) as NVARCHAR));
		PRINT('------------------------------------------------------------------------------');

		/*=====================*/
		--NewDimProduct
		/*=====================*/
		PRINT('Truncating Table: NewDimProduct');
		TRUNCATE TABLE NewDimProduct;
		PRINT('Inserting Data Into: NewDimProduct');
		SET @StartTime = GETDATE();
		
		WITH product_consolidated as (
		SELECT
			p.ProductCategoryKey,
			p.ProductCategoryAlternateKey,
			p.EnglishProductCategoryName,
			sc.EnglishProductSubcategoryName,
			sc.ProductSubcategoryKey
		FROM DimProductCategory p
		JOIN DimProductSubcategory sc ON p.ProductCategoryKey = sc.ProductCategoryKey
		)

		INSERT INTO NewDimProduct
		(
			ProductKey,
			ProductAlternateKey,
			ProductSubCategoryKey,
			ProductCategoryName,
			ProductSubCategoryName,
			ProductName,
			SafetyStockLevel,
			ReorderPoint,
			DaysToManufacture,
			StartDate,
			EndDate,
			Status 
		)

		SELECT 
			p.ProductKey,
			p.ProductAlternateKey,
			p.ProductSubcategoryKey,
			pc.EnglishProductCategoryName,
			pc.EnglishProductSubcategoryName,
			p.EnglishProductName,
			p.SafetyStockLevel,
			p.ReorderPoint,
			p.DaysToManufacture,
			CASE
				WHEN CAST(p.EndDate as DATE) < CAST(p.StartDate as DATE) THEN CAST(p.EndDate as DATE)
				ELSE CAST(p.StartDate as DATE)
			END as StartDate,
			CASE  
				WHEN CAST(p.StartDate as DATE) > CAST(p.EndDate as DATE) THEN CAST(p.StartDate as DATE)
				ELSE CAST(p.EndDate as DATE)
			END as EndDate,
			COALESCE(p.Status, 'Completed') as Status
		FROM DimProduct p
		LEFT JOIN product_consolidated pc ON p.ProductSubcategoryKey = pc.ProductSubcategoryKey;
		SET @EndTime = GETDATE()
		PRINT('Time Taken: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) as NVARCHAR));
	END TRY
/*=====================*/
--Error Handling
/*=====================*/
	BEGIN CATCH
		PRINT('Error Message:'+ ' ' + CAST(ERROR_MESSAGE() as NVARCHAR));
		PRINT('Error Number:' + ' ' + CAST(ERROR_NUMBER() as NVARCHAR));
		PRINT('Error Line:'+ ' ' + CAST(ERROR_LINE() as NVARCHAR));
	END CATCH
----------------------------------------------
END