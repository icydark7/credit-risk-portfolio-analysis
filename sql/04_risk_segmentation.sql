-- ============================================================
-- CREDIT RISK PORTFOLIO ANALYSIS
-- 04 - RISK SEGMENTATION
-- ============================================================


-- 1. Default rate by loan grade
SELECT
    loan_grade,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
        2
    ) AS default_rate
FROM credit_risk_loans
GROUP BY loan_grade
ORDER BY default_rate DESC;


-- 2. Loan grade: portfolio size, exposure and defaulted exposure
SELECT
    loan_grade,
    COUNT(*) AS loan_count,
    SUM(loan_amnt) AS total_loan_exposure,
    ROUND(
        100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
        2
    ) AS default_rate,
    SUM(
        CASE
            WHEN loan_status = 1 THEN loan_amnt
            ELSE 0
        END
    ) AS defaulted_loan_exposure
FROM credit_risk_loans
GROUP BY loan_grade
ORDER BY defaulted_loan_exposure DESC;


-- 3. Share of total portfolio exposure by loan grade
SELECT
    loan_grade,
    SUM(loan_amnt) AS total_loan_exposure,
    ROUND(
        100.0 * SUM(loan_amnt)
        / SUM(SUM(loan_amnt)) OVER (),
        2
    ) AS exposure_percentage
FROM credit_risk_loans
GROUP BY loan_grade
ORDER BY exposure_percentage DESC;


-- 4. Default rate by loan purpose
SELECT
    loan_intent,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
        2
    ) AS default_rate
FROM credit_risk_loans
GROUP BY loan_intent
ORDER BY default_rate DESC;


-- 5. Default rate by home ownership
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


-- 6. Default rate by loan burden
SELECT
    CASE
        WHEN loan_percent_income <= 0.10 THEN '10% or less'
        ELSE 'Above 10%'
    END AS loan_burden_group,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
        2
    ) AS default_rate
FROM credit_risk_loans
GROUP BY
    CASE
        WHEN loan_percent_income <= 0.10 THEN '10% or less'
        ELSE 'Above 10%'
    END
ORDER BY default_rate DESC;


-- 7. Loan burden: exposure and defaulted exposure
SELECT
    CASE
        WHEN loan_percent_income <= 0.10 THEN '10% or less'
        ELSE 'Above 10%'
    END AS loan_burden_group,
    COUNT(*) AS loan_count,
    SUM(loan_amnt) AS total_loan_exposure,
    ROUND(
        100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
        2
    ) AS default_rate,
    SUM(
        CASE
            WHEN loan_status = 1 THEN loan_amnt
            ELSE 0
        END
    ) AS defaulted_loan_exposure
FROM credit_risk_loans
GROUP BY
    CASE
        WHEN loan_percent_income <= 0.10 THEN '10% or less'
        ELSE 'Above 10%'
    END
ORDER BY default_rate DESC;


-- 8. Default rate by borrower income group
SELECT
    CASE
        WHEN person_income < 40000 THEN 'Below 40K'
        WHEN person_income <= 80000 THEN '40K-80K'
        WHEN person_income <= 120000 THEN '80K-120K'
        ELSE 'Above 120K'
    END AS income_group,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
        2
    ) AS default_rate,
    ROUND(AVG(loan_amnt), 2) AS average_loan_amount
FROM credit_risk_loans
GROUP BY
    CASE
        WHEN person_income < 40000 THEN 'Below 40K'
        WHEN person_income <= 80000 THEN '40K-80K'
        WHEN person_income <= 120000 THEN '80K-120K'
        ELSE 'Above 120K'
    END
ORDER BY default_rate DESC;


-- 9. Default rate by employment length
SELECT
    CASE
        WHEN person_emp_length IS NULL THEN 'Missing'
        WHEN person_emp_length <= 2 THEN '0-2 years'
        WHEN person_emp_length <= 5 THEN '3-5 years'
        ELSE '6+ years'
    END AS employment_group,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
        2
    ) AS default_rate
FROM credit_risk_loans
GROUP BY
    CASE
        WHEN person_emp_length IS NULL THEN 'Missing'
        WHEN person_emp_length <= 2 THEN '0-2 years'
        WHEN person_emp_length <= 5 THEN '3-5 years'
        ELSE '6+ years'
    END
ORDER BY default_rate DESC;


-- 10. Default rate by interest-rate band
SELECT
    CASE
        WHEN loan_int_rate IS NULL THEN 'Missing'
        WHEN loan_int_rate < 10 THEN 'Below 10%'
        WHEN loan_int_rate <= 15 THEN '10%-15%'
        ELSE 'Above 15%'
    END AS interest_rate_group,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
        2
    ) AS default_rate
FROM credit_risk_loans
GROUP BY
    CASE
        WHEN loan_int_rate IS NULL THEN 'Missing'
        WHEN loan_int_rate < 10 THEN 'Below 10%'
        WHEN loan_int_rate <= 15 THEN '10%-15%'
        ELSE 'Above 15%'
    END
ORDER BY default_rate DESC;


-- 11. Default rate by credit-history length
SELECT
    CASE
        WHEN cb_person_cred_hist_length <= 5 THEN '0-5 years'
        WHEN cb_person_cred_hist_length <= 10 THEN '6-10 years'
        ELSE '11+ years'
    END AS credit_history_group,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
        2
    ) AS default_rate
FROM credit_risk_loans
GROUP BY
    CASE
        WHEN cb_person_cred_hist_length <= 5 THEN '0-5 years'
        WHEN cb_person_cred_hist_length <= 10 THEN '6-10 years'
        ELSE '11+ years'
    END
ORDER BY default_rate DESC;


-- 12. Default rate by loan grade among high loan-burden borrowers
SELECT
    loan_grade,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
        2
    ) AS default_rate
FROM credit_risk_loans
WHERE loan_percent_income > 0.10
GROUP BY loan_grade
ORDER BY default_rate DESC;


-- 13. Default rate by loan burden among low-income borrowers
SELECT
    CASE
        WHEN loan_percent_income <= 0.10 THEN '10% or less'
        ELSE 'Above 10%'
    END AS loan_burden_group,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(CASE WHEN loan_status = 1 THEN 1 END) / COUNT(*),
        2
    ) AS default_rate
FROM credit_risk_loans
WHERE person_income < 40000
GROUP BY
    CASE
        WHEN loan_percent_income <= 0.10 THEN '10% or less'
        ELSE 'Above 10%'
    END
ORDER BY default_rate DESC;


-- 14. Share of total defaulted exposure by loan grade
SELECT
    loan_grade,
    SUM(loan_amnt) AS total_loan_exposure,
    SUM(
        CASE
            WHEN loan_status = 1 THEN loan_amnt
            ELSE 0
        END
    ) AS defaulted_loan_exposure,
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN loan_status = 1 THEN loan_amnt
                ELSE 0
            END
        )
        /
        SUM(
            SUM(
                CASE
                    WHEN loan_status = 1 THEN loan_amnt
                    ELSE 0
                END
            )
        ) OVER (),
        2
    ) AS share_of_defaulted_exposure
FROM credit_risk_loans
GROUP BY loan_grade
ORDER BY share_of_defaulted_exposure DESC;
