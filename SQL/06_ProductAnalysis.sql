/*
===============================================================================
Product Analysis
===============================================================================

Script Purpose:
    Evaluate product performance by analyzing sales, profitability,
    manufacturing, and product lifecycle information.

Analysis Includes:
    • Executive KPIs
    • Best Selling Products
    • Product Profitability
    • Gross Margin Analysis
    • Category Performance
    • Manufacturing Analysis
    • Product Lifecycle
    • Product Status Analysis

===============================================================================
*/


SELECT 
	COUNT(DISTINCT ProductKey) as TotalProducts,
	SUM(OrderQuantity) as TotalUnitsSold,
	SUM(SalesAmount) as TotalRevenue,
	SUM(GrossProfit) as TotalGrossProfit,
	ROUND(AVG(UnitPrice),2) as AvgSellingPrice,
	ROUND((SUM(GrossProfit) * 100/ SUM(SalesAmount)), 2) as GrossMarginPercent
FROM AnalysisBase

/*=====================*/
--Best Selling Product
/*=====================*/

SELECT
	ProductName,
	SUM(OrderQuantity) as UnitsSold,
	SUM(SalesAmount) as TotalSales,
	SUM(GrossProfit) as TotalGrossProfit,
	ROUND(SUM(GrossProfit) * 100/ SUM(NULLIF(SalesAmount, 0)), 2) as MarginPercent,
	ROUND(SUM(SalesAmount) * 100/ SUM(SUM(NULLIF(SalesAmount, 0))) OVER(), 2) Contributions,
	DENSE_RANK() OVER(ORDER BY SUM(SalesAmount) DESC) as Ranking
FROM AnalysisBase
GROUP BY ProductName
ORDER BY SUM(SalesAmount) DESC

/*=====================*/
--Profitability
/*=====================*/
WITH ProductTotals AS(
SELECT 
	ProductName,
	SUM(GrossProfit) as TotalGrossProfit,
	SUM(GrossProfit) * 100/SUM(NULLIF(SalesAmount, 0)) as Margin
FROM AnalysisBase
GROUP BY ProductName
)

SELECT 
	ProductName,
	TotalGrossProfit,
	CASE 
		WHEN TotalGrossProfit = MAX(TotalGrossProfit) OVER() THEN 'Most Profit'
		WHEN TotalGrossProfit = MIN(TotalGrossProfit) OVER() THEN 'Least Profit'
		ELSE ''
	END as ProfitSegemnt,
	Margin
FROM ProductTotals
ORDER BY TotalGrossProfit DESC


/*=====================*/
--Manufacture Analysis
/*=====================*/
SELECT 
	ProductName,
	DaysToManufacture,
	SUM(SalesAmount) as TotalRevenue,
	SUM(GrossProfit) as TotalGrossProfit
FROM AnalysisBase
GROUP BY ProductName, DaysToManufacture
ORDER BY SUM(SalesAmount) DESC


/*=====================*/
--Product Lifecycle
/*=====================*/
SELECT 
	StartDate,
	EndDate,
	SUM(SalesAmount) as Totalsales,
	DATEDIFF(YEAR, StartDate, EndDate) as ProductLifespan,
	ProductStatus
FROM AnalysisBase
GROUP BY StartDate, EndDate, DATEDIFF(YEAR, StartDate, EndDate), ProductStatus

/*=====================*/
--Operational Analysis
/*=====================*/
SELECT 
	DISTINCT ShippingDays --all of the shipping days turns out to be 7 days in this Dataset
FROM AnalysisBase