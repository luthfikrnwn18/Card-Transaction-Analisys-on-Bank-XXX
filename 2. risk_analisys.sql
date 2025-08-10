WITH segment_analisys AS(
SELECT
  COUNT(DISTINCT (id)) total_user,
  CASE
    WHEN credit_score > 800 THEN'Excellent'
    WHEN credit_score BETWEEN 740 AND 799 THEN'Very good'
    WHEN credit_score BETWEEN 670 AND 739 THEN'Good'
    WHEN credit_score BETWEEN 580 AND 669 THEN'Fair'
    ELSE 'Poor'
  END AS credit_score_class,
  -- Customer segmentation(credit score for anlyze potential risk)
      
  CASE
    WHEN current_age BETWEEN 18 AND 24 THEN 'A1 - Young Adult'
    WHEN current_age BETWEEN 25 AND 34 THEN 'A2 - Early Career'
    WHEN current_age BETWEEN 35 AND 44 THEN 'A3 - Mid Career'
    WHEN current_age BETWEEN 45 AND 54 THEN 'A4 - Mature Adult'
    WHEN current_age BETWEEN 55 AND 64 THEN 'A5 - Pre-Retirement'
    WHEN current_age BETWEEN 65 AND 74 THEN 'A6 - Early Retirement'
    WHEN current_age BETWEEN 75 AND 84 THEN 'A7 - Active Senior'
    WHEN current_age BETWEEN 85 AND 102 THEN 'A8 - Elderly'
    ELSE 'Unknown'
  END AS age_group,
  -- Customer segmentation(age group for anlyze potential risk & cross-selling)
  
  SUM(num_credit_cards)/(COUNT(DISTINCT (id))) as AVG_num_credit_cards,
  CAST(SUM(per_capita_income)/(COUNT(DISTINCT (id))) AS DECIMAL(10,2)) AVG_per_capita_income,
  CAST(SUM(total_debt)/(COUNT(DISTINCT (id))) AS DECIMAL(10,2)) AVG_total_debt,
  SUM(total_debt)/SUM(per_capita_income) as DTI_ratio,
(
  CASE
    WHEN credit_score > 800 THEN 0.20
    WHEN credit_score BETWEEN 740 AND 799 THEN 0.35
    WHEN credit_score BETWEEN 670 AND 739 THEN 0.50
    WHEN credit_score BETWEEN 580 AND 669 THEN 0.75
    ELSE 1
  END
) * COUNT(DISTINCT id) AS risk_weight_count
  -- 4 parameter to analyze Use to understand the needs, risk level, and cross-sell potential of each customer segment.
FROM  mbsu_data_analyst_test.users_data
GROUP BY  credit_score_class, age_group)
SELECT *, risk_weight_count / total_user as credit_risk_percentage
FROM segment_analisys
