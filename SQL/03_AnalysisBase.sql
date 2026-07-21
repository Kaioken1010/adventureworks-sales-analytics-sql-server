/*
===============================================================================
AnalysisBase Creation
===============================================================================

Script Purpose:
    Create a consolidated analytical table by combining the cleaned fact
    and dimension tables. This serves as the primary dataset for all
    business analyses performed in this project.

Data Included:
    • Customer information
    • Product information
    • Sales metrics
    • Order details
    • Geographic attributes
    • Shipping metrics
    • Gross Profit calculation

===============================================================================
*/

DROP TABLE IF EXISTS AnalysisBase;
SELECT
	--Order Information
	i.OrderDateKey,
	i.SalesOrderNumber,
	i.OrderDate,
	i.ShipDate,
	i.DueDate,
	CASE
		WHEN i.ShipDate IS NULL THEN NULL
		ELSE DATEDIFF(DAY, i.OrderDate, i.ShipDate)
	END as ShippingDays,
	CASE 
		WHEN i.ShipDate IS NULL     THEN 'Not Shipped'
		WHEN i.ShipDate > i.DueDate THEN 'Delayed'
		ELSE 'On Time'
	END as DeliveryStatus,
	--Customer Information
	i.CustomerKey,
	CONCAT(c.FirstName, ' ', ISNULL(c.MiddleName + ' ', ''), c.LastName) as CustomerName,
	c.BirthDate,
	c.DateFirstPurchase,
	c.Gender,
	c.MaritalStatus,
	c.YearlyIncome,
	c.CountryRegionCode as CountryCode,
	c.CountryRegionName as CountryName,
	c.StateProvinceCode as StateCode,
	c.StateProvinceName as StateName,
	--Product Information
	i.ProductKey,
	p.ProductCategoryName as ProductCategory,
	p.ProductSubCategoryName as ProductSubcategory,
	p.ProductName,
	p.DaysToManufacture,
	p.Status as ProductStatus,
	p.StartDate,
	p.EndDate,
	--Sales Information 
	i.OrderQuantity,
	i.UnitPrice,
	i.ProductStandardCost,
	i.TotalProductCost,
	i.SalesAmount,
	(i.SalesAmount - i.TotalProductCost) as GrossProfit
INTO AnalysisBase
FROM NewFactInternetSales i
LEFT JOIN NewDimCustomer c ON i.CustomerKey = c.CustomerKey
LEFT JOIN NewDimProduct p  ON i.ProductKey  = p.ProductKey

SELECT 
	*
FROM AnalysisBase