/*
===============================================================================
Customer Analysis
===============================================================================

Script Purpose:
    Analyze customer behavior, purchasing patterns, demographics, and
    customer lifetime metrics to generate actionable business insights.

Analysis Includes:
    • Executive KPIs
    • Top Customers
    • Customer Lifetime Value
    • Revenue by Gender
    • Revenue by Marital Status
    • Revenue by Geography
    • Revenue by Income
    • Age Group Analysis
    • Customer Lifespan

===============================================================================
*/


/*=========================================================
Customer report 
=========================================================*/
SELECT 
	COUNT(DISTINCT CustomerKey) TotalCustomers,
	COUNT(DISTINCT SalesOrderNumber) as TotalOrders,
	SUM(OrderQuantity) as UnitsPurchased,
	SUM(SalesAmount) as TotalRevenueByCustomer,
	SUM(SalesAmount)/COUNT(Distinct CustomerKey) as AvgRevPerCustomer,
	(SUM(SalesAmount)/COUNT(DISTINCT SalesOrderNumber)) as AvgOrderValue,
	(SUM(OrderQuantity)/COUNT(DISTINCT SalesOrderNumber)) as AvgUnitsPerOrder,
	MAX(OrderDate) as LatestOrder
FROM AnalysisBase

/*=========================================================
Top Customers By Revenue 
=========================================================*/
SELECT 
	CustomerKey,
	CustomerName,
	SUM(SalesAmount) as RevByCustomer,
	DENSE_RANK() OVER(ORDER BY SUM(SalesAmount) DESC) as Ranking,
	CASE
		WHEN SUM(SalesAmount) > 10000 THEN 'Tier 1'
		WHEN SUM(SalesAmount) < 4000 THEN 'Tier 3'
		ELSE 'Tier 2'
	END as Segment
FROM AnalysisBase
GROUP BY CustomerKey, CustomerName
ORDER BY SUM(SalesAmount) DESC


/*=========================================================
Revenue by Gender
=========================================================*/
SELECT 
	Gender,
	SUM(SalesAmount) as TotalSales,
	(SUM(SalesAmount) * 100 / (SELECT SUM(SalesAmount) FROM AnalysisBase)) as PercentOfSales
FROM AnalysisBase
GROUP BY Gender

/*=========================================================
Revenue by Marital Status
=========================================================*/
SELECT 
	MaritalStatus,
	SUM(SalesAmount) as TotalSales
FROM AnalysisBase
GROUP BY MaritalStatus

/*=========================================================
Revenue by Country
=========================================================*/
SELECT 
	CountryName,
	SUM(SalesAmount) as TotalSales,
	(SUM(SalesAmount) * 100/ (SELECT SUM(SalesAmount) FROM AnalysisBase)) as Percentage
FROM AnalysisBase
GROUP BY CountryName
ORDER BY (SUM(SalesAmount) * 100/ (SELECT SUM(SalesAmount) FROM AnalysisBase)) DESC

/*=========================================================
Revenue by State
=========================================================*/
SELECT 
	StateName,
	SUM(SalesAmount) as TotalSales,
	(SUM(SalesAmount) * 100 / (SELECT SUM(SalesAmount) FROM AnalysisBase)) as Percentage
FROM AnalysisBase
GROUP BY  StateName
ORDER BY SUM(SalesAmount) DESC



/*=========================================================
Sales By Yearly Income
=========================================================*/
SELECT 
	c.YearlyIncome,
	SUM(c.SalesAmount) as TotalSales
FROM AnalysisBase c
GROUP BY c.YearlyIncome
ORDER BY c.YearlyIncome DESC


/*=========================================================
Revenue By Age Group
=========================================================*/
WITH age AS (
SELECT 
	CustomerKey,
	BirthDate,
	SalesAmount,
	DATEDIFF(YEAR, BirthDate, GETDATE()) as Age 
FROM AnalysisBase
)

SELECT 
	FLOOR(Age/10) * 10 as AgeGroup,
	SUM(SalesAmount) as RevenueGenerated
FROM age
GROUP BY FLOOR(Age/10) * 10
ORDER BY SUM(SalesAmount) DESC

/*=========================================================
Customer Lifespan
=========================================================*/

SELECT 
	CustomerKey,
	CustomerName,
	DateFirstPurchase,
	MAX(OrderDate) as LatestPurchase,
	DATEDIFF(DAY, DateFirstPurchase, MAX(OrderDate))as Lifespan_InDays,
	DENSE_RANK() OVER(ORDER BY DATEDIFF(DAY, DateFirstPurchase, MAX(OrderDate)) DESC) as Rankings
FROM AnalysisBase
GROUP BY CustomerKey,CustomerName, DateFirstPurchase