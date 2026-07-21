/*
===============================================================================
Advanced Business Analytics
===============================================================================

Script Purpose:
    Perform advanced analytical techniques to uncover customer behavior,
    product performance, and long-term business trends using SQL Server.

Analysis Includes:
    • Pareto Analysis (80/20 Rule)
    • ABC Product Classification
    • Top Products by Category
    • RFM Customer Segmentation
    • Cohort Retention Analysis

SQL Concepts Used:
    • CTEs
    • Window Functions
    • FIRST_VALUE()
    • NTILE()
    • DENSE_RANK()
    • Running Totals

===============================================================================
*/

/*=====================*/
--Pareto Analysis
/*=====================*/
WITH ProductRevenue as (
SELECT
	ProductName,
	SUM(SalesAmount) as Revenue
FROM AnalysisBase 
GROUP BY ProductName
)
, TempTable as (
SELECT 
	ProductName,
	Revenue,
	SUM(Revenue) OVER(ORDER BY Revenue DESC) RunningRevenue,
	SUM(Revenue) OVER(ORDER BY Revenue DESC) * 100.0/ (SELECT SUM(SalesAmount) FROM AnalysisBase) as Cumulative
FROM ProductRevenue
)

SELECT 
	ProductName,
	ROUND(CAST(Revenue as FLOAT), 2) as Revenue,
	ROUND(CAST(RunningRevenue as FLOAT), 2) as RunnningRevenue,
	ROUND(CAST(Cumulative as FLOAT), 2) as Cumulative,
	CASE
		WHEN Cumulative <= 80 THEN 'A'
		WHEN Cumulative BETWEEN 80 AND 95 THEN 'B'
		ELSE 'C'
	END as ABC_Class
FROM TempTable


/*============================*/
--Top Product In Each Category
/*============================*/
WITH Ranking as (
SELECT
	ProductCategory,
	ProductName,
	SUM(SalesAmount) as Revenue,
	DENSE_RANK() OVER(PARTITION BY ProductCategory ORDER BY SUM(SalesAmount) DESC) Rankings
FROM AnalysisBase
GROUP BY ProductCategory, ProductName
)

SELECT 
	ProductCategory,
	ProductName,
	Revenue,
	Rankings
FROM Ranking
WHERE Rankings = 1


/*============================*/
--RFM Analysis
/*============================*/
WITH RMF_check AS (
SELECT 
	CustomerKey,
	CustomerName,
	MAX(OrderDate) as LatestOrder,
	DATEDIFF(DAY, MAX(OrderDate), (SELECT MAX(OrderDate) FROM AnalysisBase)) as Recency,
	COUNT(DISTINCT SalesOrderNumber) as Frequency,
	SUM(SalesAmount) AS Monetary
FROM AnalysisBase
GROUP BY CustomerKey, CustomerName
)
, Score_Analysis as (
SELECT 
	CustomerKey,
	CustomerName,
	LatestOrder,
	Recency,
	NTILE(5) OVER(ORDER BY Recency DESC) as R_Score,
	Frequency,
	NTILE(5) OVER(ORDER BY Frequency) as F_Score,
	Monetary,
	NTILE(5) OVER(ORDER BY Monetary) as M_Score
FROM RMF_check
)

SELECT 
	CustomerKey,
	CustomerName,
	LatestOrder,
	Recency,
	R_Score,
	Frequency,
	F_Score,
	Monetary,
	M_Score,
	CASE 
		WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN 'Champions' --Recent, Frequent, High Spenders
		WHEN R_Score >= 4 AND F_Score >= 4 THEN 'Loyal Customers' --Buy often and recently 
		WHEN R_Score >= 4 AND M_Score >= 4 THEN 'Big Spenders' --High value and recent customers
		WHEN R_Score <= 2 AND F_Score <= 2 THEN 'Lost Customers' --Did not buy recently and rarely purchased
		WHEN R_Score >= 4 AND F_Score <= 2 THEN 'New Customers' --Recently acquired but not frequent
		ELSE 'Potential Customers'
	END as RFM_Output
FROM Score_Analysis


/*============================*/
--Cohort Analysis 
/*============================*/
WITH CustomerCohort AS (
SELECT DISTINCT
	CustomerKey,
	CustomerName,
	DateFirstPurchase,
	DATETRUNC(MONTH, DateFirstPurchase) as CohortMonth
FROM AnalysisBase
)
, CustomerActivity AS (
SELECT 
	c.CustomerKey,
	c.CustomerName,
	c.CohortMonth,
	DATETRUNC(MONTH, a.OrderDate) as PurchaseMonth,
	DATEDIFF(MONTH, c.CohortMonth, DATETRUNC(MONTH, a.OrderDate)) as MonthNumber
FROM CustomerCohort c 
JOIN AnalysisBase a ON c.CustomerKey = a.CustomerKey
)
, CohortRetention AS(
SELECT 
	CohortMonth, 
	MonthNumber,
	COUNT(DISTINCT CustomerKey) as CustomerCount,
	FIRST_VALUE(COUNT(DISTINCT CustomerKey)) OVER(PARTITION BY CohortMonth ORDER BY MonthNumber) as CohortSize
FROM CustomerActivity
GROUP BY CohortMonth, MonthNumber
)

SELECT 
	*,
	CAST(ROUND((CustomerCount * 100.0/ MaxCount), 2) as FLOAT) as RetentionPercent
FROM CohortRetention