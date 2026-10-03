# Credit Risk Portfolio Analysis

## Project Overview

This project analyzes a consumer credit portfolio using PostgreSQL and SQL.

The analysis focuses on portfolio size, loan exposure, default behavior, risk segmentation, and concentration of defaulted exposure across different borrower and loan characteristics.

## Dataset

The dataset contains **32,581 loan records** and includes borrower, loan, and credit-history attributes such as:

- Borrower age and income
- Home ownership
- Employment length
- Loan purpose
- Loan grade
- Loan amount
- Interest rate
- Loan status
- Loan-to-income ratio
- Credit history length

### Dataset Source

Dataset sourced from Kaggle:  
[Credit Risk Dataset](https://www.kaggle.com/datasets/laotse/credit-risk-dataset)

## Business Objectives

The analysis was designed to answer questions such as:

- What is the overall default rate?
- How large is the loan portfolio?
- How does default risk vary across loan grades?
- Which borrower and loan segments show higher observed default rates?
- Where is defaulted loan exposure concentrated?
- How does loan burden relate to observed default rates?

## SQL Analysis

The project is organized into five SQL files:

### 01 — Create Table
Creates the PostgreSQL table and defines the dataset schema.

### 02 — Data Quality Checks
Checks:

- Record count
- Missing values
- Exact duplicate records
- Age anomalies
- Basic value ranges

### 03 — Portfolio KPIs
Calculates:

- Total loans
- Total loan exposure
- Average loan amount
- Average borrower income
- Overall default rate
- Average interest rate by default status
- Portfolio distribution by home ownership
- Default rate by home ownership

### 04 — Risk Segmentation
Analyzes observed default rates and exposure across:

- Loan grade
- Loan purpose
- Home ownership
- Loan burden
- Income
- Employment length
- Interest-rate bands
- Credit-history length

It also includes multi-dimensional segmentation and defaulted-exposure analysis.

### 05 — Final Analysis
Uses more advanced SQL techniques to:

- Rank loan grades by observed default rate
- Compare loan-purpose default rates against the portfolio benchmark
- Identify major contributors to defaulted exposure
- Analyze high loan-burden borrowers across loan grades
- Identify higher-risk combinations of income and loan burden

## Key Findings

| Metric | Result |
|---|---:|
| Total loans | 32,581 |
| Total loan exposure | 3.124B |
| Average loan amount | 9,589.37 |
| Overall default rate | 21.82% |
| >10% loan burden default rate | 26.61% |
| ≤10% loan burden default rate | 11.72% |
| Below 40K income default rate | 39.71% |
| D + B + C share of defaulted exposure | 71.96% |

Additional observations:

- Observed default rates varied substantially across loan grades, from **9.96% for Grade A to 98.44% for Grade G**.
- Borrowers with loan burden above 10% had a higher observed default rate than borrowers at or below 10%.
- Borrowers with income below 40K had a **39.71%** observed default rate.
- Loan grades D, B, and C together represented **71.96% of total defaulted loan exposure**.

## SQL Techniques Demonstrated

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `CASE WHEN`
- Conditional aggregation
- `FILTER`
- `HAVING`
- Common Table Expressions (CTEs)
- `CROSS JOIN`
- Window functions
- `RANK()`

## Data Quality Findings

The dataset contained:

- **895** missing employment-length values
- **3,116** missing interest-rate values
- **165** exact duplicate groups
- **5** borrower-age records above 100

These issues were identified through SQL data-quality checks and documented rather than silently removed.

## Limitations

The dataset contains loan-level information but does not include payment history, days past due, recovery amounts, or time-series repayment information.

Therefore, this project focuses on **default and exposure analysis** rather than delinquency, roll-rate, recovery, or loss-given-default metrics.

Observed relationships in the dataset should not be interpreted as proof of causation.

## Tools

- PostgreSQL
- SQL
- pgAdmin
