# AdventureWorks Sales Analytics using SQL Server

## Overview

This project is an end-to-end business analytics solution built using **Microsoft SQL Server** and the **AdventureWorksDW2025** data warehouse. It demonstrates how raw warehouse data can be transformed into actionable business insights through SQL-based ETL and analytics.

A consolidated analytical table (`AnalysisBase`) was created by integrating sales, customer, product, and geographic information into a single dataset. This dataset serves as the foundation for performing sales, customer, and product analytics as well as advanced techniques like RFM and Pareto analysis.

The project showcases SQL techniques commonly used by Data Analysts and Business Intelligence professionals, including Common Table Expressions (CTEs), Window Functions, Aggregate Functions, Ranking, and more.

---

# Project Objectives

The primary objective of this project is to simulate a real-world business analytics workflow using SQL Server by transforming the AdventureWorksDW2025 data warehouse into a clean analytical dataset suitable for reporting and analysis.

The project focuses on:

- Building a consolidated analytical dataset
- Performing sales performance analysis
- Understanding customer purchasing behavior
- Evaluating product performance and profitability
- Applying advanced analytical techniques using SQL
- Demonstrating business-oriented SQL development suitable for Data Analyst roles

---

# Dataset

**Database:** AdventureWorksDW2025

AdventureWorksDW2025 is Microsoft's sample data warehouse representing a fictional bicycle manufacturing company. The database contains historical sales, customer, product, reseller, geography, and date information useful for practicing analytics.

### Tables Used

- FactInternetSales
- DimCustomer
- DimProduct
- DimProductSubcategory
- DimProductCategory
- DimGeography
- DimDate

---

# Project Workflow

```
AdventureWorksDW2025
        │
        ▼
Exploratory Data Analysis (EDA)
        │
        ▼
Data Validation & Preparation
        │
        ▼
Creation of AnalysisBase
        │
        ▼
Business Analytics
        ├── Sales Analysis
        ├── Customer Analysis
        ├── Product Analysis
        └── Advanced Analytics
```

The project follows a structured analytics workflow beginning with data exploration and ending with business-focused reporting. A centralized analytical table named **AnalysisBase** was created to simplify downstream reporting and analysis.

---

# AnalysisBase

`AnalysisBase` is the core analytical dataset created for this project.

It combines information from multiple fact and dimension tables into a single reporting table containing:

- Sales Information
- Customer Information
- Product Information
- Geography Information
- Shipping Metrics
- Gross Profit
- Manufacturing Information
- Customer First Purchase Date

Using a centralized analytical table significantly simplifies reporting queries while improving readability and maintainability.

---

# Analysis Performed

## 1. Sales Analysis

The Sales Analysis focuses on measuring overall business performance and identifying sales trends.

### Reports Included

- Executive KPIs
- Monthly Revenue Trends
- Quarterly Performance
- Running Revenue
- Moving Average Sales
- Month-over-Month Growth
- Revenue Contribution
- Best Performing Months
- Lowest Performing Months

---

## 2. Customer Analysis

Customer Analysis provides insights into purchasing behavior and customer demographics.

### Reports Included

- Customer KPIs
- Top Customers
- Revenue by Gender
- Revenue by Marital Status
- Revenue by Country
- Revenue by State
- Revenue by Income Group
- Revenue by Age Group
- Customer Lifetime Analysis

---

## 3. Product Analysis

Product Analysis evaluates product performance and profitability.

### Reports Included

- Product KPIs
- Best Selling Products
- Gross Profit Analysis
- Gross Margin %
- Revenue Contribution
- Product Profitability
- Manufacturing Analysis
- Product Lifecycle Analysis
- Top Products by Category

---

## 4. Advanced Analytics

The project also demonstrates several advanced SQL analytical techniques.

### Pareto Analysis

Identifies products contributing to approximately 80% of total revenue.

### ABC Classification

Classifies products into:

- A Class
- B Class
- C Class

based on cumulative revenue contribution.

### RFM Analysis

Customer segmentation using:

- Recency
- Frequency
- Monetary Value

Customers are categorized into segments such as:

- Champions
- Loyal Customers
- Potential Loyalists
- At Risk
- Lost Customers

### Cohort Analysis

Measures customer retention over time by grouping customers according to their first purchase month and calculating monthly retention percentages.

---

# SQL Concepts Demonstrated

This project demonstrates a wide range of SQL Server concepts, including:

- Common Table Expressions (CTEs)
- Window Functions
- Aggregate Functions
- Ranking Functions
- CASE Expressions
- Date Functions
- Analytical Functions
- Joins
- GROUP BY
- HAVING
- Subqueries
- Data Transformation
- Business KPI Calculations

Window functions used include:

- ROW_NUMBER()
- DENSE_RANK()
- LAG()
- FIRST_VALUE()
- SUM() OVER()
- AVG() OVER()
- NTILE()

---

# Repository Structure

```
AdventureWorks-Sales-Analytics-SQL-Server
│
├── README.md
│
├── sql
│   ├── 00_EDA.sql
│   ├── 01_DDLScripts.sql
│   ├── 02_DataInsertion.sql
│   ├── 03_AnalysisBase.sql
│   ├── 04_SalesAnalysis.sql
│   ├── 05_CustomerAnalysis.sql
│   ├── 06_ProductAnalysis.sql
│   └── 07_AdvancedAnalytics.sql
│
└── images
```

---

# How to Run

1. Restore or attach the AdventureWorksDW2025 database.
2. Execute the scripts in the following order:

```
00_EDA.sql
01_DDLScripts.sql
02_DataInsertion.sql
03_AnalysisBase.sql
04_SalesAnalysis.sql
05_CustomerAnalysis.sql
06_ProductAnalysis.sql
07_AdvancedAnalytics.sql
```

3. Review the generated reports and analytical outputs.

---

# Skills Demonstrated

- Microsoft SQL Server
- Data Cleaning
- Data Transformation
- Data Modeling
- Business Analytics
- KPI Reporting
- Window Functions
- Customer Analytics
- Product Analytics
- Sales Analytics
- Cohort Analysis
- RFM Analysis
- Pareto Analysis
- ABC Classification

---

# Author

**Jayesh Kumar**

Data Analyst | SQL | Business Analytics | Data Visualization

LinkedIn: https://www.linkedin.com/in/jayesh-kumar10

If you found this project helpful, feel free to star the repository.
