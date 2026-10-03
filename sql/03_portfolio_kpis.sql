-- ============================================================
-- CREDIT RISK PORTFOLIO ANALYSIS
-- 03 - PORTFOLIO KPIs
-- ============================================================


-- 1. Total number of loans
SELECT
    COUNT(*) AS total_loans
FROM credit_risk_loans;


-- 2. Total loan exposure
SELECT
    SUM(loan_amnt) AS total_loan_exposure
FROM credit_risk_loans;


-- 3. Average loan amount
SELECT
    ROUND(AVG(loan_amnt), 2) AS average_loan_amount
FROM credit_risk_loans;


-- 4. Average borrower income
SELECT
    ROUND(AVG(person_income), 2) AS average_borrower_income
FROM credit_risk_loans;


-- 5. Overall default rate
SELECT
    ROUND(
        100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
        2
    ) AS overall_default_rate
FROM credit_risk_loans;


-- 6. Loan count and default rate by loan status
SELECT
    loan_status,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
        2
    ) AS portfolio_percentage
FROM credit_risk_loans
GROUP BY loan_status
ORDER BY loan_status;


-- 7. Average interest rate by default status
SELECT
    loan_status,
    ROUND(AVG(loan_int_rate), 2) AS average_interest_rate
FROM credit_risk_loans
GROUP BY loan_status
ORDER BY loan_status;


-- 8. Borrower distribution by home ownership
SELECT
    person_home_ownership,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS portfolio_percentage
FROM credit_risk_loans
GROUP BY person_home_ownership
ORDER BY loan_count DESC;


-- 9. Default rate by home ownership
SELECT
    person_home_ownership,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
        2
    ) AS default_rate
FROM credit_risk_loans
GROUP BY person_home_ownership
ORDER BY default_rate DESC;
