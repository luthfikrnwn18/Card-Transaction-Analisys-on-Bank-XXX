CREATE OR REPLACE TABLE mbsu_datamart.transaction_2019 AS
SELECT *
FROM transactions_data
WHERE year(DATE) = 2019
