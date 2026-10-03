-- ============================================================
-- CREDIT RISK PORTFOLIO ANALYSIS
-- 05 - FINAL ANALYSIS
-- ============================================================


-- 1. Rank loan grades by observed default rate
-- Demonstrates: RANK(), FILTER, GROUP BY, window functions

SELECT
    loan_grade,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE loan_status = 1) / COUNT(*),
        2
    ) AS default_rate,
    RANK() OVER (
        ORDER BY
            COUNT(*) FILTER (WHERE loan_status = 1) * 1.0 / COUNT(*) DESC
    ) AS default_rate_rank
FROM credit_risk_loans
GROUP BY loan_grade
ORDER BY default_rate_rank;


-- 2. Identify loan purposes above the overall portfolio
-- Demonstrates: CTE, CROSS JOIN, benchmark comparison

WITH portfolio_benchmark AS (
    SELECT
        ROUND(
            100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
            2
        ) AS portfolio_default_rate
    FROM credit_risk_loans
),
purpose_analysis AS (
    SELECT
        loan_intent,
        COUNT(*) AS loan_count,
        ROUND(
            100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
            2
        ) AS default_rate
    FROM credit_risk_loans
    GROUP BY loan_intent
)
SELECT
    purpose_analysis.loan_intent,
    purpose_analysis.loan_count,
    purpose_analysis.default_rate,
    portfolio_benchmark.portfolio_default_rate
FROM purpose_analysis
CROSS JOIN portfolio_benchmark
WHERE purpose_analysis.default_rate
      > portfolio_benchmark.portfolio_default_rate
ORDER BY purpose_analysis.default_rate DESC;

-- 3. Identify the main contributors to defaulted exposure
-- Demonstrates: conditional aggregation and window functions

SELECT
    loan_grade,
    SUM(loan_amnt) AS total_loan_exposure,
    SUM(loan_amnt) FILTER (WHERE loan_status = 1)
        AS defaulted_loan_exposure,
    ROUND(
        100.0 *
        SUM(loan_amnt) FILTER (WHERE loan_status = 1)
        /
        SUM(SUM(loan_amnt) FILTER (WHERE loan_status = 1)) OVER (),
        2
    ) AS share_of_defaulted_exposure
FROM credit_risk_loans
GROUP BY loan_grade
ORDER BY share_of_defaulted_exposure DESC;


-- 4. Compare risk for borrowers with high loan burden
-- across loan grades
-- Demonstrates: WHERE, GROUP BY, conditional aggregation

SELECT
    loan_grade,
    COUNT(*) AS loan_count,
    COUNT(*) FILTER (WHERE loan_status = 1) AS defaulted_loans,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE loan_status = 1) / COUNT(*),
        2
    ) AS default_rate
FROM credit_risk_loans
WHERE loan_percent_income > 0.10
GROUP BY loan_grade
HAVING COUNT(*) >= 100
ORDER BY default_rate DESC;


-- 5. Identify high-risk combinations of income and loan burden
-- Demonstrates: multi-dimensional segmentation and HAVING

SELECT
    CASE
        WHEN person_income < 40000 THEN 'Below 40K'
        WHEN person_income <= 80000 THEN '40K-80K'
        WHEN person_income <= 120000 THEN '80K-120K'
        ELSE 'Above 120K'
    END AS income_group,
    CASE
        WHEN loan_percent_income <= 0.10 THEN '10% or less'
        ELSE 'Above 10%'
    END AS loan_burden_group,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE loan_status = 1) / COUNT(*),
        2
    ) AS default_rate,
    SUM(loan_amnt) AS total_loan_exposure
FROM credit_risk_loans
GROUP BY
    CASE
        WHEN person_income < 40000 THEN 'Below 40K'
        WHEN person_income <= 80000 THEN '40K-80K'
        WHEN person_income <= 120000 THEN '80K-120K'
        ELSE 'Above 120K'
    END,
    CASE
        WHEN loan_percent_income <= 0.10 THEN '10% or less'
        ELSE 'Above 10%'
    END
HAVING COUNT(*) >= 100
ORDER BY default_rate DESC;
