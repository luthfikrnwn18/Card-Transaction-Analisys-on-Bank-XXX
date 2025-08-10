CREATE OR REPLACE TABLE mbsu_datamart.merchant_analysis AS
SELECT 
    merchant_id,
    merchant_city,
    merchant_state,
    zip,
    DATE(CONCAT(YEAR(date), '-', MONTH(date), '-01')) AS transaction_month,
    SUM(amount_cleaned) AS total_amount_cleaned,
    COUNT(DISTINCT id) AS total_transaction
FROM transactions_data_2019
GROUP BY 
    transaction_month,
    merchant_id,
    merchant_city,
    merchant_state,
    zip;
