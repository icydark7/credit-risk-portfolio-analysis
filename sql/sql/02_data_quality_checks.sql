-- ============================================================
-- CREDIT RISK PORTFOLIO ANALYSIS
-- 02 - DATA QUALITY CHECKS
-- ============================================================


-- 1. Total number of records
SELECT
    COUNT(*) AS total_records
FROM credit_risk_loans;


-- 2. Missing values by important column
SELECT
    COUNT(*) FILTER (WHERE person_age IS NULL) AS missing_person_age,
    COUNT(*) FILTER (WHERE person_income IS NULL) AS missing_person_income,
    COUNT(*) FILTER (WHERE person_emp_length IS NULL) AS missing_person_emp_length,
    COUNT(*) FILTER (WHERE loan_int_rate IS NULL) AS missing_loan_int_rate,
    COUNT(*) FILTER (WHERE loan_status IS NULL) AS missing_loan_status
FROM credit_risk_loans;


-- 3. Exact duplicate records
SELECT
    COUNT(*) AS duplicate_groups
FROM (
    SELECT
        *
    FROM credit_risk_loans
    GROUP BY
        person_age,
        person_income,
        person_home_ownership,
        person_emp_length,
        loan_intent,
        loan_grade,
        loan_amnt,
        loan_int_rate,
        loan_status,
        loan_percent_income,
        cb_person_default_on_file,
        cb_person_cred_hist_length
    HAVING COUNT(*) > 1
) AS duplicates;


-- 4. Borrower age anomalies
SELECT
    person_age,
    COUNT(*) AS record_count
FROM credit_risk_loans
WHERE person_age > 100
GROUP BY person_age
ORDER BY person_age;


-- 5. Basic range checks
SELECT
    MIN(person_age) AS min_age,
    MAX(person_age) AS max_age,
    MIN(person_income) AS min_income,
    MAX(person_income) AS max_income,
    MIN(loan_amnt) AS min_loan_amount,
    MAX(loan_amnt) AS max_loan_amount,
    MIN(loan_percent_income) AS min_loan_percent_income,
    MAX(loan_percent_income) AS max_loan_percent_income
FROM credit_risk_loans;
