/*
===============================================================================
Data Definition Language (DDL)
===============================================================================

Script Purpose:
    Create the analytical tables used throughout the project. These tables
    provide a clean and optimized structure for business reporting and
    advanced SQL analysis.

Objects Created:
    • NewFactInternetSales
    • NewDimCustomer
    • NewDimProduct

===============================================================================
*/

CREATE OR ALTER PROCEDURE NewTables as 

	BEGIN
		DECLARE @StartTime DATETIME, @EndTime DATETIME 
		
		BEGIN TRY
		/*=====================*/
		--NewFactInternetSales
		/*=====================*/
		SET @StartTime = GETDATE()
		IF OBJECT_ID ('NewFactInternetSales', 'U') IS NOT NULL
		DROP TABLE NewFactInternetSales;


		CREATE TABLE NewFactInternetSales
		(
			ProductKey INT,
			OrderDateKey INT,
			CustomerKey INT,
			SalesOrderNumber NVARCHAR(100),
			OrderQuantity INT,
			UnitPrice DECIMAL(19,4),
			ProductStandardCost DECIMAL(19,4),
			TotalProductCost DECIMAL(19,4),
			SalesAmount DECIMAL(19,4),
			OrderDate DATE,
			DueDate DATE,
			ShipDate DATE
		)
		SET @EndTime = GETDATE()
		PRINT('NewFactInternetSales created:' + ' ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) as NVARCHAR));

		/*=====================*/
		----NewDimCustomer
		/*=====================*/
		SET @StartTime = GETDATE()
		IF OBJECT_ID ('NewDimCustomer', 'U') IS NOT NULL
		DROP TABLE NewDimCustomer;

		CREATE TABLE NewDimCustomer
		(
			CustomerKey INT,
			GeographyKey INT,
			CustomerAlternateKey NVARCHAR(50),
			FirstName NVARCHAR(50),
			MiddleName NVARCHAR(50),
			LastName NVARCHAR(50),
			City NVARCHAR(50),
			StateProvinceCode NVARCHAR(50),
			StateProvinceName NVARCHAR(50),
			CountryRegionCode NVARCHAR(50),
			CountryRegionName NVARCHAR(50),
			BirthDate DATE,
			MaritalStatus NVARCHAR(50),
			Gender NVARCHAR(50),
			EmailAddress NVARCHAR(50),
			YearlyIncome DECIMAL(19,4),
			DateFirstPurchase DATE
		)
		SET @EndTime = GETDATE()
		PRINT('NewDimCustomer created:' + ' ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) as NVARCHAR));
		
		/*=====================*/
		--NewDimProduct
		/*=====================*/
		SET @StartTime = GETDATE()
		IF OBJECT_ID ('NewDimProduct', 'U') IS NOT NULL
		DROP TABLE NewDimProduct;

		CREATE TABLE NewDimProduct
		(
			ProductKey INT,
			ProductAlternateKey NVARCHAR(50),
			ProductSubCategoryKey INT,
			ProductCategoryName NVARCHAR(50),
			ProductSubCategoryName NVARCHAR(50),
			ProductName NVARCHAR(50),
			SafetyStockLevel BIGINT,
			ReorderPoint INT,
			DaysToManufacture INT,
			StartDate DATE,
			EndDate DATE,
			Status NVARCHAR(50)
		)
		SET @EndTime = GETDATE()
		PRINT('NewDimProduct created:' + ' ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) as NVARCHAR));
		
		
		END TRY
			BEGIN CATCH
				PRINT('Error Message:'+ ' ' + CAST(ERROR_MESSAGE() as NVARCHAR));
				PRINT('Error Number:' + ' ' + CAST(ERROR_NUMBER() as NVARCHAR));
				PRINT('Error Line:'+ ' ' + CAST(ERROR_LINE() as NVARCHAR));
			END CATCH
	END