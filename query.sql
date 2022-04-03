-- Before we start digging into the SQL script - let’s cover the business questions that we need to help the GM answer!
-- 1. How many unique users exist in the logs dataset?
SELECT COUNT(DISTINCT id) AS "Number of Unique IDs" FROM health.user_logs;

 Number of Unique IDs
----------------------
                  554

-- Now, let us create a temporary table for the next few questions:
DROP TABLE IF EXISTS user_measure_count;
CREATE TEMP TABLE user_measure_count AS (
  SELECT
    id,
    COUNT(*) AS measure_count,
    COUNT(DISTINCT measure) as unique_measures
  FROM health.user_logs
  GROUP BY id
);

-- 2. How many total measurements do we have per user on average?
SELECT
  ROUND(AVG(measure_count)) AS "AVERAGE"
FROM user_measure_count;

 Average
---------
      79 

-- 3. What about the median number of measurements per user?
SELECT 
   PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY measure_count) AS median_value 
FROM user_measure_count;

 median_value
--------------
            2
    

-- 4. How many users have 3 or more measurements?
SELECT
  COUNT(*)
FROM user_measure_count
WHERE measure_count >= 3;

 count
-------
   209

-- 5. How many users have 1,000 or more measurements?
SELECT
  COUNT(*)
FROM user_measure_count
WHERE measure_count >= 1000;

 count
-------
     5

-- Looking at the logs data - what is the number and percentage of the active user base who:

-- 6. Have logged blood glucose measurements?
-- Number of the active user base logging blood glucose measurements:
SELECT COUNT(DISTINCT id) AS "Users Logging Blood Glucose"
FROM health.user_logs
WHERE measure = 'blood_glucose';

 Users Logging Blood Glucose
-----------------------------
                         325

--Percentage of the active user base logging blood glucose measurements:
DROP TABLE IF EXISTS groupby_table;
CREATE TEMP TABLE groupby_table AS (
  SELECT
    id,
    measure,
    SUM(COUNT(DISTINCT id)) OVER() AS user_count
  FROM health.user_logs
  GROUP BY
    id,
    measure
);

WITH final_table AS (
  SELECT
    COUNT(*) AS blood_glucose_count,
    user_count
    -- ROUND(100 * blood_glucose_count / user_count) AS percentage
  FROM groupby_table
  WHERE measure = 'blood_glucose'
  GROUP BY user_count
)
SELECT
  blood_glucose_count,
  user_count,
  ROUND(100 * blood_glucose_count / user_count, 2) AS percentage
FROM final_table;

 blood_glucose_count | user_count | percentage
---------------------+------------+------------
                 325 |        808 |      40.22

-- 7. Have at least 2 types of measurements?
WITH user_measure_count AS (
  SELECT
    id,
    COUNT(*) AS measure_count,
    COUNT(DISTINCT measure) as unique_measures
  FROM health.user_logs
  GROUP BY id
)
SELECT
  COUNT(*)
FROM user_measure_count
WHERE unique_measures >= 2;

 count
-------
   204

-- 8. Have all 3 measures - blood glucose, weight and blood pressure?
-- Observe how many unique measures are in the dataset:
SELECT DISTINCT(measure) FROM health.user_logs;
-- Since there are 3 unique measures 'blood_glucose', 'blood_pressure' and 'weight'
WITH user_measure_count AS (
  SELECT
    id,
    COUNT(*) AS measure_count,
    COUNT(DISTINCT measure) as unique_measures
  FROM health.user_logs
  GROUP BY id
)
SELECT
  COUNT(*)
FROM user_measure_count
WHERE unique_measures = 3;

 count
-------
    50

-- For users that have blood pressure measurements:

-- 9. What is the median systolic/diastolic blood pressure values?
SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY systolic) AS "Median Systolic Value",
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY diastolic) AS "Median Value Diastolic"
FROM health.user_logs
WHERE measure = 'blood_pressure';

 Median Systolic Value | Median Value Diastolic
-----------------------+------------------------
                   126 |                     79
