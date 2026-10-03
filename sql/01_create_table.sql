-- ============================================================
-- CREDIT RISK PORTFOLIO ANALYSIS
-- 01 - CREATE TABLE
-- ============================================================

CREATE TABLE credit_risk_loans (
    person_age INTEGER,
    person_income BIGINT,
    person_home_ownership VARCHAR(20),
    person_emp_length NUMERIC,
    loan_intent VARCHAR(50),
    loan_grade VARCHAR(5),
    loan_amnt NUMERIC,
    loan_int_rate NUMERIC,
    loan_status INTEGER,
    loan_percent_income NUMERIC,
    cb_person_default_on_file VARCHAR(5),
    cb_person_cred_hist_length INTEGER
);
