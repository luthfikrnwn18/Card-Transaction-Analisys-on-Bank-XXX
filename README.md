# 📊 Bank XXX Card Transaction Analysis

## Data Analyst - Technical Test by Luthfi Kurniawan

This project aims to analyze card transaction data from Bank XXX to identify business risks and opportunities. This analysis was created as part of a technical test.

### 🚀 Analysis Objectives

The analysis focuses on two main goals:

1.  **Credit Disbursement Risk Data Presentation**: Identify and present data related to the risk of providing credit.
2.  **Cross-Selling Opportunities Identification**: Find cross-selling opportunities from users who own a credit card but **had no transactions during 2019**.

**Success Metric:** Achieve revenue growth while minimizing risk.

---

### 💾 Data Sources

This project uses several data tables that were joined:

| Table Name | Description |
| :--- | :--- |
| `mbsu_data_analyst_test.users_data` | User demographic and profile data. |
| `mbsu_data_analyst_test.cards_data` | Details of credit cards owned by users. |
| `mbsu_data_analyst_test.transaction_data` | Transaction history data. |

> **Note:** For this analysis, we only used transaction data from **2019** to formulate a strategy for 2020.
* **Dump SQL File : Structure & Data (Google Drive):**
    [![Google Drive](https://img.shields.io/badge/Files-Google%20Drive-orange)](https://drive.google.com/drive/folders/1j3RWvQlhqyWvl7Xq3Yh-wWkSJ0VSGPOg?usp=sharing)

---

### 👩‍💻 Analysis Steps (SQL Queries)

Here are the steps taken in this analysis, using SQL syntax.

#### **Step 1: Retrieve 2019 Transaction Data**

The first step is to filter the transaction data for the year 2019 only.

```sql
CREATE OR REPLACE TABLE mbsu_data_analyst_test.transactions_data_2019 AS
SELECT *
FROM transactions_data
WHERE year(DATE) = 2019;
```

#### **Step 2: User, Transaction & Card Analysis for Risk**
`The mbsu_datamart.risk_analyst` table was created to consolidate user, card, and transaction information. This table is used to calculate key metrics such as the debt-to-income ratio and classify credit scores according to Basel II/III standards.
```sql
CREATE OR REPLACE TABLE mbsu_datamart.risk_analyst AS
SELECT 
    A.id,
    A.num_credit_cards AS total_card,
    SUM(C.amount_cleaned) AS total_amount_cleaned,
    COUNT(DISTINCT C.id) AS total_transaction,
    SUM(DISTINCT B.credit_limit) AS total_credit_limit,
    CAST(A.per_capita_income / 12 AS DECIMAL(10,0)) AS income_per_month,
    A.total_debt,
    CAST(A.total_debt / (A.per_capita_income / 12) AS DECIMAL(10,2)) AS Debt_to_income_ratio,
    CASE
        WHEN A.credit_score > 800 THEN 'Excellent'
        WHEN A.credit_score BETWEEN 740 AND 799 THEN 'Very good'
        WHEN A.credit_score BETWEEN 670 AND 739 THEN 'Good'
        WHEN A.credit_score BETWEEN 580 AND 669 THEN 'Fair'
        ELSE 'Poor'
    END AS credit_score_class,
    A.longitude,
    A.latitude
FROM users_data A                          
LEFT JOIN cards_data B 
    ON A.id = B.client_id
LEFT JOIN transactions_data_2019 C 
    ON B.id = C.card_id
GROUP BY A.id;
```
### **Step 3: Merchant Transaction Analysis**
This analysis focuses on transaction behavior at the merchant level.
```sql
SELECT 
    merchant_id,
    merchant_city,
    merchant_state,
    zip,
    DATE(CONCAT(YEAR(date), '-', MONTH(date), '-01')) AS transaction_month,
    SUM(DISTINCT amount_cleaned) AS total_credit_limit,
    COUNT(DISTINCT(id)) as total_trancaction
FROM transactions_data_2019
GROUP BY transaction_month, merchant_id, merchant_city, merchant_state;
```
### 📈 Results & Visualizations

Here are the links to the visualization and presentation of this analysis.

* **Presentation (Google Slides):**
    [![Google Slides Presentation](https://img.shields.io/badge/Presentation-Google%20Slides-brightgreen)](https://docs.google.com/presentation/d/1g6xXD_NYIIjrQ5XNkw3nwJ9XIS4Rvc1cOjNuw81AI9E/edit?usp=sharing)
* **Dashboard (Looker Studio):**
    [![Looker Studio Dashboard](https://img.shields.io/badge/Dashboard-Looker%20Studio-blue)](https://lookerstudio.google.com/reporting/be01a6d3-2a82-46a5-92bc-ab68abb14a6a)



