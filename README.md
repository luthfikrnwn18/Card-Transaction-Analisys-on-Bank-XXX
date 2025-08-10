# Card-Transaction-Analisys-on-Bank-XXX
Analysis Objective  In this analysis, I aim to:  Present data on credit disbursement risk.  Identify cross-selling opportunities from users who own a credit card but had no transactions in 2019.  Success Metric: Achieve revenue growth while minimizing risk.

##README
##Data Analyst - Technical Test by Luthfi Kurniawan


##DATA DICTIONARY
##Table: main_data (`mbsu_data_analyst_testusers_data`,`mbsu_data_analyst_testcards_data`,`mbsu_data_analyst_test.transaction_data`)
##Table: analysis_table (`mbsu_datamartdatamart.risk_analyst`)

##Only using 2019 data, to make strategic plan 2020 & red

----------------------------Step 1 : take transaction data 2019-------------------------------
CREATE OR REPLACE TABLE mbsu_data_analyst_test.transactions_data_2019 AS
SELECT *
FROM transactions_data
WHERE year(DATE) = 2019;
----------------------Step 2 : Analyze user, transaction & card -------------------------------
CREATE OR REPLACE TABLE mbsu_datamart.risk_analyst AS
SELECT 
    A.id,
    A.num_credit_cards AS total_card,
    SUM(C.amount_cleaned) AS total_amount_cleaned,       -- <- calculated GMV on 2019
    COUNT(DISTINCT C.id) AS total_transaction,           -- <- calculated GMV on 2019
    SUM(DISTINCT B.credit_limit) AS total_credit_limit,  -- <- distinct agar tidak double
    CAST(A.per_capita_income / 12 AS DECIMAL(10,0)) AS income_per_month, -- <- asumsisition AVG permonth income to paid debt
    A.total_debt,
    CAST(A.total_debt / (A.per_capita_income / 12) AS DECIMAL(10,2)) AS Debt_to_income_ratio, -- <- Basel II/III Standardized Approach 
    CASE
        WHEN A.credit_score > 800 THEN 'Excellent'
        WHEN A.credit_score BETWEEN 740 AND 799 THEN 'Very good'
        WHEN A.credit_score BETWEEN 670 AND 739 THEN 'Good'
        WHEN A.credit_score BETWEEN 580 AND 669 THEN 'Fair'
        ELSE 'Poor'
    END AS credit_score_class,   -- <- Basel II/III Standardized Approach 
    A.longitude,
    A.latitude
FROM users_data A                          
LEFT JOIN cards_data B 
    ON A.id = B.client_id
LEFT JOIN transactions_data_2019 C 
    ON B.id = C.card_id
GROUP BY A.id;
----------------------Step 3 : Merchant transaction analisys  -------------------------------
SELECT 
    merchant_id,
    merchant_city,
    merchant_state,
    zip,
    DATE(CONCAT(YEAR(date), '-', MONTH(date), '-01')) AS transaction_month,
    SUM(DISTINCT amount_cleaned) AS total_credit_limit,
    COUNT(DISTINCT(id)) as total_trancaction
FROM transactions_data_2019
GROUP BY transaction_month,merchant_id, merchant_city, merchant_state
----------------------------------------------------------------------------------------------

##In this analysis, I aim to present data on credit disbursement risk, as well as cross-selling opportunities from users who own a card but had no transactions in 2019.
Success Metric: Achieve revenue growth while minimizing risk.##


#Presentation link : https://docs.google.com/presentation/d/1g6xXD_NYIIjrQ5XNkw3nwJ9XIS4Rvc1cOjNuw81AI9E/edit?usp=sharing
#Looker Link : https://lookerstudio.google.com/reporting/be01a6d3-2a82-46a5-92bc-ab68abb14a6a
