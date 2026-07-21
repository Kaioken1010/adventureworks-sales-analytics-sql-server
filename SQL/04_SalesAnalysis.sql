/*
===============================================================================
Sales Analysis
===============================================================================

Script Purpose:
    Analyze sales performance and business KPIs to identify revenue trends,
    growth patterns, and overall business performance.

Analysis Includes:
    • Executive KPIs
    • Monthly Sales Trends
    • Quarter-wise Performance
    • Month-over-Month Growth
    • Running Revenue
    • Revenue Contribution
    • Best and Worst Sales Months

===============================================================================
*/


/*=====================*/
--KPI Analysis
/*=====================*/

SELECT
    ROUND(SUM(SalesAmount), 2) as TotalSales,
    COUNT(DISTINCT SalesOrderNumber) as TotalOrders,
    COUNT(DISTINCT CustomerKey) as TotalCustomers,
    COUNT(OrderQuantity) as UnitsSold,
    AVG(SalesAmount) as AvgSales
FROM NewFactInternetSales

/*=====================*/
--Sales Trend Analysis
/*=====================*/

--Monthly Revenue
WITH MonthlySales AS (
SELECT
    DATETRUNC(MONTH, OrderDate) as OrderMonth,
    SUM(SalesAmount) as SaleByMonth
FROM NewFactInternetSales
GROUP BY DATETRUNC(MONTH, OrderDate)
)
, Delta AS(
SELECT
    OrderMonth,
    SaleByMonth,
    LAG(SaleByMonth) OVER(ORDER BY OrderMonth) as PrevSales,
    (SaleByMonth - LAG(SaleByMonth) OVER(ORDER BY OrderMonth)) as SalesDelta
FROM MonthlySales
)

SELECT 
    'Q' + CAST(DATEPART(QUARTER, OrderMonth) as NVARCHAR) as Quarter,
    OrderMonth,
    DATENAME(MONTH, OrderMonth) as MonthName,
    SaleByMonth,
    PrevSales,
    SalesDelta,
    CASE
        WHEN SalesDelta > 0 THEN 'Increase'
        WHEN SalesDelta < 0 THEN 'Decrease'
        ELSE 'No Change'
    END as Status,
    CASE
        WHEN PrevSales IS NULL OR PrevSales = 0 THEN NULL
        ELSE (CAST(ROUND((SalesDelta * 100/PrevSales), 2) as NVARCHAR) + '%')
    END as MonthlyGrowth,
    ROUND(SUM(SaleByMonth) OVER(ORDER BY OrderMonth), 2) as RunningTotal,
    ROUND(AVG(SaleByMonth) OVER(), 2) AS AvgMonthlySales,
    CASE
        WHEN SaleByMonth > ROUND(AVG(SaleByMonth) OVER(), 2) THEN 'Above Average'
        WHEN SaleByMonth < ROUND(AVG(SaleByMonth) OVER(), 2) THEN 'Below Average'
        ELSE 'Average'
    END as AvgSaleStatus,
    (SaleByMonth * 100/ SUM(SaleByMonth) OVER()) as Contribution,
    CASE 
        WHEN SaleByMonth = MAX(SaleByMonth) OVER() THEN 'Highest Sale'
        WHEN SaleByMonth = MIN(SaleByMonth) OVER() THEN 'Lowest Sale'
        ELSE ''
    END as BestOrWorst_Month
FROM Delta