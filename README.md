# SQL Health Analytics Case Study
[🍦 View My Profile](https://github.com/chris-minsik-son)
[🍰 View Repositories](https://github.com/chris-minsik-son?tab=repositories)
[🍨 View Main Folder](https://github.com/chris-minsik-son/SQL-Code)

This repository contains the Health Analytics Case Study from the Data With Danny Serious SQL Course.

---

## Table of Contents
  - [Context](#context)
  - [Case Study Questions](#case-study-questions)
  - [Solutions](#solutions)

## Context
We’ve just received an urgent request from the General Manager of Analytics at Health Co requesting our assistance with their analysis of the ```health.user_logs``` dataset.

The Health Co analytics team have shared with us their SQL script - they unfortunately ran into a few bugs that they couldn’t fix!

We’ve been asked to quickly debug their SQL script and use the resulting query outputs to quickly answer a few questions that the GM has requested for a board meeting about their active users.


## Case Study Questions
Before we start digging into the SQL script - let’s cover the business questions that we need to help the GM answer!

1. How many unique users exist in the logs dataset?
2. How many total measurements do we have per user on average?
3. What about the median number of measurements per user?
4. How many users have 3 or more measurements?
5. How many users have 1,000 or more measurements?

Looking at the logs data - what is the number and percentage of the active user base who:

6. Have logged blood glucose measurements?
7. Have at least 2 types of measurements?
8. Have all 3 measures - blood glucose, weight and blood pressure?

For users that have blood pressure measurements:
9. What is the median systolic/diastolic blood pressure values?

## Solutions
**1. How many unique users exist in the logs dataset?**
```sql
SELECT
    COUNT(DISTINCT id) AS "Number of Unique IDs"
FROM health.user_logs;
```

| Number of Unique IDs |
|----------------------|
|                  554 |

---

```sql
DROP TABLE IF EXISTS user_measure_count;
CREATE TEMP TABLE user_measure_count AS (
  SELECT
    id,
    COUNT(*) AS measure_count,
    COUNT(DISTINCT measure) as unique_measures
  FROM health.user_logs
  GROUP BY id
);
```

---

**2. How many total measurements do we have per user on average?**
```sql
SELECT
  ROUND(AVG(measure_count)) AS "average"
FROM user_measure_count;
```

| average |
|---------|
|      79 |

---

**3. What about the median number of measurements per user?**
NA

**4. How many users have 3 or more measurements?**
```sql
SELECT
  COUNT(*)
FROM user_measure_count
WHERE measure_count >= 3;
```

| count |
|-------|
|   209 |

---

**5. How many users have 1,000 or more measurements?**
```sql
SELECT
  COUNT(*)
FROM user_measure_count
WHERE measure_count >= 1000;
```

| count |
|-------|
|     5 |

---

Looking at the logs data - what is the number and percentage of the active user base who:

**6. Have logged blood glucose measurements?**
**7. Have at least 2 types of measurements?**
**8. Have all 3 measures - blood glucose, weight and blood pressure?**

For users that have blood pressure measurements:
**9. What is the median systolic/diastolic blood pressure values?**