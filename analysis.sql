/* ============================================================
   Customer Churn Analysis & Retention Insights
   Database : churn_db
   Table    : telco_churn  (created by clean_churn.py)
   Author   : Jyoti Ranjan Barik
   ============================================================ */

USE churn_db;

-- ------------------------------------------------------------
-- 0. Quick check: table loaded correctly
-- ------------------------------------------------------------
SELECT COUNT(*) AS total_rows FROM telco_churn;
SELECT * FROM telco_churn LIMIT 5;

-- ------------------------------------------------------------
-- 1. Overall churn rate (headline KPI)
-- ------------------------------------------------------------
SELECT COUNT(*)                                          AS total_customers,
       SUM(Churn = 'Yes')                                AS churned_customers,
       ROUND(100 * SUM(Churn = 'Yes') / COUNT(*), 2)     AS churn_rate_pct
FROM telco_churn;

-- ------------------------------------------------------------
-- 2. Churn by contract type
--    Question: which contract type loses the most customers?
-- ------------------------------------------------------------
SELECT Contract,
       COUNT(*)                                          AS customers,
       SUM(Churn = 'Yes')                                AS churned,
       ROUND(100 * SUM(Churn = 'Yes') / COUNT(*), 2)     AS churn_rate_pct
FROM telco_churn
GROUP BY Contract
ORDER BY churn_rate_pct DESC;

-- ------------------------------------------------------------
-- 3. Churn by tenure bucket
--    Question: do new customers leave faster than old ones?
-- ------------------------------------------------------------
SELECT CASE WHEN tenure <= 12 THEN '0-12 months'
            WHEN tenure <= 24 THEN '13-24 months'
            WHEN tenure <= 48 THEN '25-48 months'
            ELSE '49+ months' END                        AS tenure_group,
       COUNT(*)                                          AS customers,
       ROUND(100 * SUM(Churn = 'Yes') / COUNT(*), 2)     AS churn_rate_pct
FROM telco_churn
GROUP BY tenure_group
ORDER BY MIN(tenure);

-- ------------------------------------------------------------
-- 4. Rank payment methods by churn rate (window function)
-- ------------------------------------------------------------
SELECT PaymentMethod,
       customers,
       churn_rate_pct,
       RANK() OVER (ORDER BY churn_rate_pct DESC)        AS risk_rank
FROM (
    SELECT PaymentMethod,
           COUNT(*)                                      AS customers,
           ROUND(100 * SUM(Churn = 'Yes') / COUNT(*), 2) AS churn_rate_pct
    FROM telco_churn
    GROUP BY PaymentMethod
) t;

-- ------------------------------------------------------------
-- 5. High-risk customer segment (CTE)
--    Rule: month-to-month + tenure <= 12 months + monthly charge > 70
-- ------------------------------------------------------------
WITH risk AS (
    SELECT customerID,
           MonthlyCharges,
           Churn,
           CASE WHEN Contract = 'Month-to-month'
                 AND tenure <= 12
                 AND MonthlyCharges > 70
                THEN 'High Risk' ELSE 'Normal' END       AS risk_segment
    FROM telco_churn
)
SELECT risk_segment,
       COUNT(*)                                          AS customers,
       ROUND(100 * SUM(Churn = 'Yes') / COUNT(*), 2)     AS churn_rate_pct,
       ROUND(AVG(MonthlyCharges), 2)                     AS avg_monthly_charge
FROM risk
GROUP BY risk_segment;

-- ------------------------------------------------------------
-- 6. Churn by internet service and tech support
--    Question: does tech support reduce churn?
-- ------------------------------------------------------------
SELECT InternetService,
       TechSupport,
       COUNT(*)                                          AS customers,
       ROUND(100 * SUM(Churn = 'Yes') / COUNT(*), 2)     AS churn_rate_pct
FROM telco_churn
WHERE InternetService <> 'No'
GROUP BY InternetService, TechSupport
ORDER BY InternetService, churn_rate_pct DESC;

-- ------------------------------------------------------------
-- 7. Revenue at risk: monthly revenue lost to churned customers
-- ------------------------------------------------------------
SELECT ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END), 2) AS monthly_revenue_lost,
       ROUND(SUM(MonthlyCharges), 2)                                   AS total_monthly_revenue,
       ROUND(100 * SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END)
                 / SUM(MonthlyCharges), 2)                             AS revenue_lost_pct
FROM telco_churn;

-- ------------------------------------------------------------
-- 8. Top 10 churned customers by total charges (subquery)
-- ------------------------------------------------------------
SELECT customerID, Contract, tenure, MonthlyCharges, TotalCharges
FROM telco_churn
WHERE Churn = 'Yes'
  AND TotalCharges > (SELECT AVG(TotalCharges) FROM telco_churn)
ORDER BY TotalCharges DESC
LIMIT 10;
